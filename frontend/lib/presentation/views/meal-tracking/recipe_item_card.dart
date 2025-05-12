import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        elevation: 2,
        child: InkWell(
          onTap: () => _handleTap(context),
          onLongPress:
              onRemove != null ? () => _showDeleteConfirmation(context) : null,
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
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
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(Icons.verified, size: 14.h, color: Colors.blue),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        recipe.calories,
                        style: TextStyle(
                          fontSize: 13.sp,
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
