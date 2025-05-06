package com.uth.nutriai.security;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ProblemDetail;
import org.springframework.lang.NonNull;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;
import org.springframework.security.web.util.matcher.RequestMatcher;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Component
public class TokenAuthenticationFilter extends OncePerRequestFilter {

    private static final String AUTHORIZATION_HEADER = "Authorization";
    private static final String BEARER_PREFIX = "Bearer ";
    private final List<RequestMatcher> skipMatchers = Stream.of(
            "/api/auth/**",
            "/api/health",
            "/swagger-ui/**",
            "/swagger-ui.html",
            "/swagger-resources/**",
            "/v3/api-docs/**",
            "/v3/api-docs",
            "/webjars/**",
            "/openapi.yaml",
            "/api/recipes/**",
            "/api/health-tracking/*",
            "/api/meal-logs/*"
    ).map(AntPathRequestMatcher::new).collect(Collectors.toList());
    @Autowired
    private ObjectMapper objectMapper;
    @Autowired
    private GoogleTokenVerifier googleTokenVerifier;

    @Override
    protected boolean shouldNotFilter(@NonNull HttpServletRequest request) {
        return skipMatchers.stream().anyMatch(matcher -> matcher.matches(request));
    }

    @Override
    protected void doFilterInternal(
            @NonNull HttpServletRequest request,
            @NonNull HttpServletResponse response,
            @NonNull FilterChain filterChain
    ) throws ServletException, IOException {

        if (shouldNotFilter(request)) {
            filterChain.doFilter(request, response);
            return;
        }

        Optional<String> token = extractTokenFromRequest(request);

        if (token.isPresent() && !token.get().isEmpty()) {

            String sub = extractUserIdFromToken(token.get());

            List<GrantedAuthority> authorities = Collections.singletonList(new SimpleGrantedAuthority("ROLE_USER"));
            var authentication = new UsernamePasswordAuthenticationToken(sub, null, authorities);
            authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
            SecurityContextHolder.getContext().setAuthentication(authentication);

            filterChain.doFilter(request, response);
        } else {
            SecurityContextHolder.clearContext();
            setAuthErrorDetails(response);
        }
    }

    private String extractUserIdFromToken(String token) {

        try {
            return googleTokenVerifier.verify(token).getSubject();
        } catch (Exception e) {
            throw new RuntimeException("Error extracting user id from token", e);
        }
    }

    private Optional<String> extractTokenFromRequest(HttpServletRequest request) {
        return Optional.ofNullable(request.getHeader(AUTHORIZATION_HEADER))
                .filter(header -> header.startsWith(BEARER_PREFIX))
                .map(header -> header.replace(BEARER_PREFIX, ""));
    }

    private void setAuthErrorDetails(HttpServletResponse response) throws IOException {
        HttpStatus httpStatus = HttpStatus.valueOf(HttpServletResponse.SC_UNAUTHORIZED);
        response.setStatus(httpStatus.value());
        response.setContentType(MediaType.APPLICATION_JSON_VALUE);
        ProblemDetail problemDetail = ProblemDetail.forStatusAndDetail(
                httpStatus,
                "Authentication failure: Token missing, invalid or expired"
        );
        response.getWriter().write(objectMapper.writeValueAsString(problemDetail));
    }
}
