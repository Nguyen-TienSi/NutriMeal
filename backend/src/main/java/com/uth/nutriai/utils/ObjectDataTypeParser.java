package com.uth.nutriai.utils;

import lombok.SneakyThrows;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.Arrays;
import java.util.Objects;
import java.util.UUID;
import java.util.function.Function;

public class ObjectDataTypeParser {

    private static final ParserFunction<?>[] PARSERS = {
            new ParserFunction<>(Integer::parseInt),
            new ParserFunction<>(Long::parseLong),
            new ParserFunction<>(Double::parseDouble),
            new ParserFunction<>(UUID::fromString),
            new ParserFunction<>(obj -> LocalDate.parse(obj)
                    .atStartOfDay(ZoneId.systemDefault())
                    .toInstant()
                    .toEpochMilli()),
    };

    public static Object parse(Object value) {
        if (value == null) return null;

        if ("true".equalsIgnoreCase(value.toString()) || "false".equalsIgnoreCase(value.toString())) {
            return Boolean.parseBoolean(value.toString());
        }

        return Arrays.stream(PARSERS)
                .map(parser -> {
                    try {
                        return parser.tryParse(value.toString());
                    } catch (Exception ex) {
                        return null;
                    }
                })
                .filter(Objects::nonNull)
                .findFirst()
                .orElse(value);
    }

    private record ParserFunction<T>(Function<String, T> parser) {
        Object tryParse(String value) {
            return parser.apply(value);
        }
    }
}
