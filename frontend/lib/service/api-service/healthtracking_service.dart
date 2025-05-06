import 'package:nutriai_app/data/repositories/api_repository.dart';
import 'package:nutriai_app/data/repositories/dio_api_provider.dart';

class HealthtrackingService {
  final ApiRepository _apiRepository =
      ApiRepository(apiProvider: DioApiProvider());
}
