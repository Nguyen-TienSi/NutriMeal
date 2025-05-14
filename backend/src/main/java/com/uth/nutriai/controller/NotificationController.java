package com.uth.nutriai.controller;

import com.uth.nutriai.service.INotificationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping(value = "/api/notifications", produces = "application/vnd.company.app-v1+json")
public class NotificationController {

    @Autowired
    private INotificationService notificationService;

    @RequestMapping("/send-notification")
    public ResponseEntity<Void> sendNotification(@RequestBody NotificationRequest notificationRequest) {

        notificationService.sendNotification(notificationRequest.title, notificationRequest.body);

        return ResponseEntity.noContent().build();
    }

    public record NotificationRequest(String title, String body) {}
}
