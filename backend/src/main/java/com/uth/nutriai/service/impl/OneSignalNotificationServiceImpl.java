package com.uth.nutriai.service.impl;

import com.uth.nutriai.dao.IUserDao;
import com.uth.nutriai.model.domain.User;
import com.uth.nutriai.service.INotificationService;
import com.uth.nutriai.utils.SecurityUtils;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
@Slf4j
public class OneSignalNotificationServiceImpl implements INotificationService {

    @Value("${onesignal.app.id}")
    private String appId;

    @Value("${onesignal.api.key}")
    private String apiKey;

    @Value("${onesignal.url}")
    private String url;

    @Autowired
    private IUserDao userDao;

    @Override
    public void sendNotification(String title, String message, List<User> users) {
        List<UUID> userIds = users.stream()
                .map(User::getId)
                .toList();
        sendNotificationToUsers(title, message, userIds);
    }

    @Override
    public void sendNotification(String title, String message, User user) {
        sendNotificationToUsers(title, message, List.of(user.getId()));
    }

    @Override
    public void sendNotification(String title, String message) {
        String userId = SecurityUtils.extractAccountId();
        User user = userDao.findByUserId(userId).orElseThrow(() ->
                new IllegalArgumentException("User not found with id: " + userId));
        sendNotification(title, message, user);
    }

    private void sendNotificationToUsers(String title, String message, List<UUID> userIds) {
        try {
            RestTemplate restTemplate = new RestTemplate();
            HttpEntity<Map<String, Object>> requestEntity = buildNotificationRequest(title, message, userIds);
            ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.POST, requestEntity, String.class);

            if (!response.getStatusCode().is2xxSuccessful()) {
                throw new NotificationException("Failed to send notification: " + response.getBody());
            }
        } catch (Exception e) {
            log.error("Error sending notification", e);
            throw new NotificationException("Error sending notification: " + e.getMessage(), e);
        }
    }

    private HttpEntity<Map<String, Object>> buildNotificationRequest(String title, String message, List<UUID> userIds) {
        HttpHeaders headers = new HttpHeaders();
        headers.set("Content-Type", "application/json;");
        headers.set("Authorization", "Key " + apiKey);

        Map<String, Object> body = new HashMap<>();
        body.put("app_id", appId);
        body.put("include_external_user_ids", userIds);
        body.put("contents", Map.of("en", message));
        body.put("headings", Map.of("en", title));
        body.put("target_channel", "push");

        return new HttpEntity<>(body, headers);
    }

    private static class NotificationException extends RuntimeException {
        public NotificationException(String message) {
            super(message);
        }

        public NotificationException(String message, Throwable cause) {
            super(message, cause);
        }
    }
}
