import 'package:flutter/material.dart';
import 'package:nutriai_app/data/models/recipe_summary_data.dart';
import 'package:nutriai_app/service/api-service/recipe_service.dart';
import 'package:nutriai_app/presentation/views/recipe/recipe_detail_screen.dart';
import 'package:uuid/uuid_value.dart';
import 'recipe_item_card.dart';

class SearchRecipeSection extends StatefulWidget {
  final String? value;
  final Function(RecipeSummaryData)? onRecipeSelected;
  final UuidValue mealLogId;

  const SearchRecipeSection({
    super.key,
    this.value,
    this.onRecipeSelected,
    required this.mealLogId,
  });

  @override
  State<SearchRecipeSection> createState() => _SearchRecipeSectionState();
}

class _SearchRecipeSectionState extends State<SearchRecipeSection> {
  List<RecipeSummaryData> recipeSummaryList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.value != null && widget.value!.isNotEmpty) {
      fetchRecipeSummaryList();
    }
  }

  @override
  void didUpdateWidget(SearchRecipeSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value &&
        widget.value != null &&
        widget.value!.isNotEmpty) {
      fetchRecipeSummaryList();
    }
  }

  Future<void> fetchRecipeSummaryList() async {
    try {
      setState(() => isLoading = true);
      final recipeSummaryList = await RecipeService().searchRecipeSummaryList(
        value: widget.value,
      );
      setState(() {
        this.recipeSummaryList = recipeSummaryList;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching recipe summary list: $e');
      setState(() => isLoading = false);
    }
  }

  void _handleRecipeSelected(RecipeSummaryData recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetailScreen(
          id: recipe.id!,
          mealLogId: widget.mealLogId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (recipeSummaryList.isEmpty) {
      return const Center(
        child: Text(
          'No recipes found',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Search Results',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Flexible(
          child: ListView.builder(
            itemCount: recipeSummaryList.length,
            itemBuilder: (context, index) {
              final recipe = recipeSummaryList[index];
              return RecipeItemCard(
                recipe: recipe,
                onTap: () => _handleRecipeSelected(recipe),
                isSearchResult: true,
              );
            },
          ),
        ),
      ],
    );
  }
}
