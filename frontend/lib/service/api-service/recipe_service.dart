import 'package:nutriai_app/data/models/recipe_summary_data.dart';
import 'package:nutriai_app/data/repositories/api_repository.dart'
    show ApiRepository;
import 'package:nutriai_app/data/repositories/http_api_provider.dart'
    show HttpApiProvider;

class RecipeService {
  final ApiRepository apiRepository =
      ApiRepository(apiProvider: HttpApiProvider());

  Future<List<RecipeSummaryData>> fetchRecipeSummaryList() async {
    final response = await apiRepository.fetchData(endPoint: 'recipes');
    if (response.containsKey('data') && response['data'] is List) {
      final List<dynamic> recipeList = response['data'];
      return recipeList
          .map((item) => RecipeSummaryData.fromJson(item))
          .toList();
    } else {
      throw Exception('⚠️ Response format invalid: ${response.toString()}');
    }
  }
}
