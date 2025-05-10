import 'package:flutter/material.dart';
import 'package:nutriai_app/data/models/user_create_data.dart';
import 'package:nutriai_app/data/models/user_detail_data.dart';
import 'package:nutriai_app/data/repositories/api_repository.dart';
import 'package:nutriai_app/data/repositories/http_api_provider.dart';
import 'package:nutriai_app/data/repositories/json_patch.dart';

class UserService {
  final ApiRepository apiRepository =
      ApiRepository(apiProvider: HttpApiProvider());

  Future<dynamic> createUser(UserCreateData userCreateData) async {
    try {
      return await apiRepository.sendData<dynamic>(
          endPoint: '/users', data: userCreateData);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserDetailData?> getUserDetailData() async {
    try {
      return await apiRepository.fetchData<dynamic>(
          endPoint: '/users/search',
          fromJson: (json) => UserDetailData.fromJson(json));
    } catch (e) {
      debugPrint('Error fetching user detail: $e');
      return null;
    }
  }

  Future<UserDetailData?> patchUserDetailData(JsonPatch patch) async {
    try {
      return await apiRepository.patchData<dynamic>(
          endPoint: '/users',
          data: patch.operations,
          fromJson: (json) => UserDetailData.fromJson(json));
    } catch (e) {
      debugPrint('Error patching user detail: $e');
      return null;
    }
  }
}
