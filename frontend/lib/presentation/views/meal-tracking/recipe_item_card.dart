import 'package:flutter/material.dart';
import 'package:nutriai_app/data/models/recipe_summary_data.dart';

class RecipeItemCard extends StatelessWidget {
  final RecipeSummaryData recipe;

  const RecipeItemCard({
    super.key,
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          recipe.recipeName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const Icon(Icons.verified,
                            size: 14, color: Colors.blue),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      recipe.calories,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.close, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
