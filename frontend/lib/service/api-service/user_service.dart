import 'package:flutter/material.dart';
import 'package:nutriai_app/data/models/user_create_data.dart';
import 'package:nutriai_app/data/repositories/api_repository.dart';
import 'package:nutriai_app/data/repositories/http_api_provider.dart';

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
}
