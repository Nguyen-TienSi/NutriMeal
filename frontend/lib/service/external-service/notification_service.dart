import 'package:flutter/material.dart';
import 'package:nutriai_app/data/models/user_detail_data.dart';
import 'package:nutriai_app/service/api-service/user_service.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class NotificationService {
  Future<void> loginUserToOnesignal(UserDetailData? userDetailData) async {
    userDetailData ??= await UserService().getUserDetailData();
    try {
      if (userDetailData?.id != null) {
        await OneSignal.login(userDetailData!.id!.toString());
        await OneSignal.User.pushSubscription.optIn();
        debugPrint(
          "🟢 OneSignal: Logged in user with external_id: ${userDetailData.id} and opted in to notifications.",
        );
      }
    } catch (e) {
      debugPrint("🔴 OneSignal: Error logging in user: $e");
    }
  }

  Future<void> logoutUserFromOnesignal() async {
    try {
      await OneSignal.logout();
      await OneSignal.User.pushSubscription.optOut();
      debugPrint(
          "🔴 OneSignal: Logged out user and opted out of notifications.");
    } catch (e) {
      debugPrint("🔴 OneSignal: Error logging out user: $e");
    }
  }

  Future<void> enableNotifications() async {
    try {
      await OneSignal.User.pushSubscription.optIn();
      debugPrint("🟢 OneSignal: User opted in to notifications.");
    } catch (e) {
      debugPrint("🔴 OneSignal: Error enabling notifications: $e");
    }
  }

  Future<void> disableNotifications() async {
    try {
      await OneSignal.User.pushSubscription.optOut();
      debugPrint("🔴 OneSignal: User opted out of notifications.");
    } catch (e) {
      debugPrint("🔴 OneSignal: Error disabling notifications: $e");
    }
  }
}
