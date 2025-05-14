package com.uth.nutriai.config;

import io.github.cdimascio.dotenv.Dotenv;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class DotEnvConfig {
    @Bean
    Dotenv dotenv() {
        return Dotenv.configure()
                .directory("./")
                .ignoreIfMissing()
                .load();
    }

    public static void load() {
        Dotenv dotenv = Dotenv.configure()
                .directory("./")
                .ignoreIfMissing()
                .load();

        // MongoDB configuration
        System.setProperty("MONGO_URI", dotenv.get("MONGO_URI"));
        System.setProperty("MONGO_DATABASE", dotenv.get("MONGO_DATABASE"));

        // OAuth2 configuration
        System.setProperty("GOOGLE_CLIENT_ID", dotenv.get("GOOGLE_CLIENT_ID"));
        System.setProperty("GOOGLE_CLIENT_SECRET", dotenv.get("GOOGLE_CLIENT_SECRET"));

        // OneSignal configuration
        System.setProperty("ONESIGNAL_APP_ID", dotenv.get("ONESIGNAL_APP_ID"));
        System.setProperty("ONESIGNAL_API_KEY", dotenv.get("ONESIGNAL_API_KEY"));

        // Application configuration
        System.setProperty("APP_DOMAIN", dotenv.get("APP_DOMAIN"));
    }
}
