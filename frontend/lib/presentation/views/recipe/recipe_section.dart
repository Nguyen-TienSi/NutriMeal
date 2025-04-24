import 'package:flutter/material.dart';
import 'package:nutriai_app/data/models/recipe_summary_data.dart'
    show RecipeSummaryData;
import 'package:nutriai_app/data/repositories/api_repository.dart';
import 'package:nutriai_app/data/repositories/http_api_provider.dart'
    show HttpApiProvider;
import 'package:nutriai_app/service/api-service/recipe_service.dart';
import 'recipe_card.dart' show RecipeCard;

class RecipeSection extends StatefulWidget {
  final String title;
  final VoidCallback onSeeAllPressed;

  const RecipeSection({
    super.key,
    required this.title,
    required this.onSeeAllPressed,
  });

  @override
  State<RecipeSection> createState() => _State();
}

class _State extends State<RecipeSection> {
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
      if (mounted) {
        setState(() {
          fetchedRecipeSummaryList = fetchedData;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('❌ Error fetching recipes: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
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

    final List<Widget> renderedRecipeCards = fetchedRecipeSummaryList
        .map((recipe) => RecipeCard(
              recipeSummaryData: recipe,
            ))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: widget.onSeeAllPressed,
                child: const Text(
                  'See all',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4.0),
        SizedBox(
          height: 250,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            itemCount: renderedRecipeCards.length,
            itemBuilder: (context, index) => renderedRecipeCards[index],
            separatorBuilder: (context, index) => const SizedBox(width: 4.0),
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
          ),
        ),
      ],
    );
  }
}
