import 'package:flutter/material.dart';
import 'package:nutriai_app/data/models/recipe_summary_data.dart';
import 'package:nutriai_app/presentation/views/recipe/recipe_detail_screen.dart';

class RecipeItemCard extends StatelessWidget {
  final RecipeSummaryData recipe;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;
  final bool isSearchResult;

  const RecipeItemCard({
    super.key,
    required this.recipe,
    this.onTap,
    this.onRemove,
    this.isSearchResult = false,
  });

  Future<void> _showDeleteConfirmation(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove Recipe'),
          content:
              Text('Are you sure you want to remove "${recipe.recipeName}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('DELETE'),
            ),
          ],
        );
      },
    );

    if (result == true && onRemove != null) {
      onRemove!();
    }
  }

  void _handleTap(BuildContext context) {
    if (isSearchResult) {
      onTap?.call();
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecipeDetailScreen(id: recipe.id!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 2,
        child: InkWell(
          onTap: () => _handleTap(context),
          onLongPress:
              onRemove != null ? () => _showDeleteConfirmation(context) : null,
          borderRadius: BorderRadius.circular(16),
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
                          Expanded(
                            child: Text(
                              recipe.recipeName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
