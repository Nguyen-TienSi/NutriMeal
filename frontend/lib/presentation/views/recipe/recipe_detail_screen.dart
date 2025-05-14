import 'package:flutter/material.dart';
import 'package:nutriai_app/data/models/recipe_detail_data.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutriai_app/service/api-service/recipe_service.dart';
import 'package:nutriai_app/service/api-service/meal_log_service.dart';
import 'package:nutriai_app/data/repositories/json_patch.dart';
import 'package:uuid/uuid_value.dart';

class RecipeDetailScreen extends StatefulWidget {
  final UuidValue id;
  final UuidValue? mealLogId;

  const RecipeDetailScreen({
    super.key,
    required this.id,
    this.mealLogId,
  });

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  RecipeDetailData? recipeDetailData;
  bool isLoading = true;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    _fetchRecipeDetailData();
  }

  Future<void> _fetchRecipeDetailData() async {
    if (!mounted) return;
    try {
      setState(() => isLoading = true);
      final recipeDetailData = await RecipeService().getRecipeDetail(widget.id);
      setState(() {
        this.recipeDetailData = recipeDetailData;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching recipe detail data: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> _saveToMealLog() async {
    if (recipeDetailData == null) return;
    if (!mounted) return;

    setState(() => isSaving = true);
    try {
      final jsonPatch = JsonPatch()
        ..add('/recipes/-', {'id': widget.id.toString()});

      final result = await MealLogService().patchMealLogDetailData(
        widget.mealLogId!,
        jsonPatch,
      );

      if (result != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Recipe added to meal log successfully'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } else {
        throw Exception('Failed to save recipe to meal log');
      }
    } catch (e) {
      debugPrint('Error saving recipe to meal log: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add recipe: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isSaving = false);
      }
    }
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20.sp, color: Colors.grey[600]),
          SizedBox(width: 8.w),
          Flexible(
            child: Text(
              '$label $value',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagChip(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.green.withAlpha(100),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.green,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (recipeDetailData == null) {
      return const Center(child: Text('Failed to load recipe details.'));
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.asset(
                recipeDetailData!.imageUrl,
                width: 1.sw, // or double.infinity
                height: 300.h,
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 100.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withAlpha(200),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Recipe Name
                Text(
                  recipeDetailData!.recipeName,
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.h),

                _buildInfoRow(
                  Icons.timer_outlined,
                  'Cooking Time',
                  '${recipeDetailData!.cookingTime} mins',
                ),
                SizedBox(width: 16.h),
                _buildInfoRow(
                  Icons.people_outline,
                  'Servings',
                  '${recipeDetailData!.serving} ${recipeDetailData!.servingUnit}',
                ),
                SizedBox(height: 16.h),

                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: recipeDetailData!.foodTags
                      .map((tag) => _buildTagChip(tag.name))
                      .toList(),
                ),
                SizedBox(height: 24.h),

                Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  recipeDetailData!.description,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey[800],
                    height: 1.5.h,
                  ),
                ),
                SizedBox(height: 24.h),

                Text(
                  'Ingredients',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),
                ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recipeDetailData!.ingredients.length,
                  itemBuilder: (context, index) {
                    final ingredient = recipeDetailData!.ingredients[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.h),
                      child: Row(
                        children: [
                          Icon(Icons.circle, size: 8.sp, color: Colors.green),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              '${ingredient.name} - ${ingredient.quantity} ${ingredient.unit}',
                              style: TextStyle(fontSize: 16.sp),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: 24.h),

                Text(
                  'Instructions',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  recipeDetailData!.instructions,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey[800],
                    height: 1.5.h,
                  ),
                ),
                SizedBox(height: 24.h),

                Text(
                  'Nutritional Information',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recipeDetailData!.nutrients.length,
                  itemBuilder: (context, index) {
                    final nutrient = recipeDetailData!.nutrients[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            nutrient.name,
                            style: TextStyle(fontSize: 16.sp),
                          ),
                          Text(
                            '${nutrient.value} ${nutrient.unit}',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: 32.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (!isLoading &&
              recipeDetailData != null &&
              widget.mealLogId != null)
            TextButton.icon(
              onPressed: isSaving ? null : _saveToMealLog,
              icon: isSaving
                  ? SizedBox(
                      width: 20.r,
                      height: 20.r,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Icon(Icons.add, color: Colors.white, size: 24.sp),
              label: Text(
                isSaving ? 'Saving...' : 'Add to Meal',
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
              ),
            ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(),
    );
  }
}
