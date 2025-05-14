package com.uth.nutriai.service;

import com.uth.nutriai.model.domain.User;

import java.util.List;

public interface INotificationService {

    void sendNotification(String title, String message, List<User> users);

    void sendNotification(String title, String message, User user);

    void sendNotification(String title, String message);
}
