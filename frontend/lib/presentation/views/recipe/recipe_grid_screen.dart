import 'package:flutter/material.dart';
import 'package:nutriai_app/data/models/recipe_summary_data.dart'
    show RecipeSummaryData;
import 'package:nutriai_app/service/api-service/recipe_service.dart'
    show RecipeService;
import 'recipe_card.dart' show RecipeCard;

class DishGridScreen extends StatefulWidget {
  const DishGridScreen({super.key});

  @override
  State<DishGridScreen> createState() => _DishGridScreenState();
}

class _DishGridScreenState extends State<DishGridScreen> {
  final RecipeService recipeService = RecipeService();
  List<RecipeSummaryData> fetchedRecipeSummaryList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRecipes();
  }

  Future<void> fetchRecipes() async {
    try {
      final fetchedData = await recipeService.fetchRecipeSummaryList();
      _updateState(fetchedData, false);
    } catch (e) {
      debugPrint('❌ Error fetching recipes: $e');
      _updateState([], false);
    }
  }

  void _updateState(List<RecipeSummaryData> recipes, bool loading) {
    if (mounted) {
      setState(() {
        fetchedRecipeSummaryList = recipes;
        isLoading = loading;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (fetchedRecipeSummaryList.isEmpty) {
      return const Center(child: Text('No recipes available.'));
    }

    return Scaffold(
      body: SafeArea(
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 200 / 250,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
          ),
          padding: const EdgeInsets.all(4.0),
          itemCount: fetchedRecipeSummaryList.length,
          itemBuilder: (context, index) {
            return RecipeCard(
                recipeSummaryData: fetchedRecipeSummaryList[index]);
          },
        ),
      ),
    );
  }
}
