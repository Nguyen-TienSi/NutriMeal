import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutriai_app/data/models/recipe_summary_data.dart';
import 'package:nutriai_app/presentation/views/meal-tracking/recipe_item_card.dart';
import 'package:nutriai_app/service/api-service/statistic_service.dart';

class FavoriteRecipeScreen extends StatefulWidget {
  const FavoriteRecipeScreen({super.key});

  @override
  State<FavoriteRecipeScreen> createState() => _FavoriteRecipeScreenState();
}

class _FavoriteRecipeScreenState extends State<FavoriteRecipeScreen> {
  List<RecipeSummaryData>? recipeSummaryDataList;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      setState(() => isLoading = true);
      final recipeSummaryDataList =
          await StatisticService().getFavoriteRecipeList();
      setState(() {
        this.recipeSummaryDataList = recipeSummaryDataList;
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Recipes'),
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : recipeSummaryDataList == null || recipeSummaryDataList!.isEmpty
                ? Center(
                    child: Text(
                      'No favorite recipes yet.',
                      style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    itemCount: recipeSummaryDataList!.length,
                    itemBuilder: (_, index) {
                      final recipe = recipeSummaryDataList![index];
                      return RecipeItemCard(recipe: recipe);
                    },
                  ),
      ),
    );
  }
}
