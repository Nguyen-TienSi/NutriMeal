import 'package:nutriai_app/data/models/recipe_summary_data.dart';
import 'package:nutriai_app/data/repositories/api_repository.dart'
    show ApiRepository;
import 'package:nutriai_app/data/repositories/dio_api_provider.dart';
import 'package:nutriai_app/data/repositories/http_api_provider.dart'
    show HttpApiProvider;
import 'package:nutriai_app/exception/unnamed_exception.dart';

class RecipeService {
  final ApiRepository apiRepository =
      ApiRepository(apiProvider: DioApiProvider());

  Future<List<RecipeSummaryData>> fetchRecipeSummaryList() async {
    return await apiRepository.fetchData<List<RecipeSummaryData>>(
      endPoint: 'recipes',
      fromJson: (data) {
        if (data is List) {
          return data.map((item) => RecipeSummaryData.fromJson(item)).toList();
        } else {
          throw UnnamedException('Invalid data format');
        }
      },
    );
  }
}
