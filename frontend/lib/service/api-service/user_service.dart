import 'package:nutriai_app/data/models/user_create_data.dart';
import 'package:nutriai_app/data/repositories/api_repository.dart'
    show ApiRepository;
import 'package:nutriai_app/data/repositories/dio_api_provider.dart'
    show DioApiProvider;

class UserService {
  final ApiRepository apiRepository =
      ApiRepository(apiProvider: DioApiProvider());

  Future<void> createUser(UserCreateData userCreateData) async {
    await apiRepository.sendData(endPoint: '/users', data: userCreateData);
  }
}
