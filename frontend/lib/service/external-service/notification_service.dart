import 'package:flutter/material.dart';
import 'package:nutriai_app/data/models/user_detail_data.dart';
import 'package:nutriai_app/service/api-service/user_service.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class NotificationService {
  Future<void> loginUserToOnesignal(UserDetailData? userDetailData) async {
    userDetailData ??= await UserService().getUserDetailData();
    if (userDetailData?.id != null) {
      await OneSignal.login(userDetailData!.id!.toString());
      await OneSignal.User.pushSubscription.optIn();
      debugPrint(
          "🟢 OneSignal: Logged in user with external_id: ${userDetailData.id}");
    }
  }

  Future<void> logoutUserFromOnesignal() async {
    await OneSignal.logout();
    await OneSignal.User.pushSubscription.optOut();
    debugPrint("🔴 OneSignal: Logged out user.");
  }
}
