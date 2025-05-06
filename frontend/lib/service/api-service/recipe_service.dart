import 'package:nutriai_app/data/models/recipe_summary_data.dart'
    show RecipeSummaryData;
import 'package:nutriai_app/data/repositories/api_repository.dart'
    show ApiRepository;
import 'package:nutriai_app/data/repositories/http_api_provider.dart'
    show HttpApiProvider;
import 'package:nutriai_app/exception/unnamed_exception.dart'
    show UnnamedException;

class RecipeService {
  final ApiRepository apiRepository =
      ApiRepository(apiProvider: HttpApiProvider());

  Future<List<RecipeSummaryData>> fetchRecipeSummaryList() async {
    return await apiRepository.fetchData<List<RecipeSummaryData>>(
      endPoint: '/recipes',
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
