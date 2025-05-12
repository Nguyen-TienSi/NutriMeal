import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutriai_app/data/models/meal_log_detail_data.dart';
import 'package:nutriai_app/data/models/recipe_summary_data.dart';
import 'package:nutriai_app/data/repositories/json_patch.dart';
import 'nutrients_progress_section.dart';
import 'recipe_item_card.dart';
import 'package:nutriai_app/service/api-service/meal_log_service.dart';
import 'package:uuid/uuid_value.dart';

class NutritionalInfoSection extends StatefulWidget {
  final UuidValue mealLogId;

  const NutritionalInfoSection({super.key, required this.mealLogId});

  @override
  State<NutritionalInfoSection> createState() => NutritionalInfoSectionState();
}

class NutritionalInfoSectionState extends State<NutritionalInfoSection> {
  MealLogDetailData? mealLogDetailData;
  bool isLoading = true;
  List<RecipeSummaryData>? recipeSummaryDataList;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      setState(() => isLoading = true);
      final mealLogDetailData =
          await MealLogService().getMealLogDetailData(widget.mealLogId);
      final recipeSummaryDataList = await MealLogService()
          .fetchRecipeSummaryListByMealLogId(widget.mealLogId);
      setState(() {
        this.mealLogDetailData = mealLogDetailData;
        this.recipeSummaryDataList = recipeSummaryDataList;
      });
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _handleRemoveRecipe(RecipeSummaryData recipe) async {
    try {
      if (recipeSummaryDataList == null) return;

      final index = recipeSummaryDataList!.indexOf(recipe);
      if (index == -1) {
        throw Exception('Recipe not found in list');
      }

      final jsonPatch = JsonPatch().remove('/recipes/$index');

      final updatedMealLog = await MealLogService()
          .patchMealLogDetailData(widget.mealLogId, jsonPatch);

      if (updatedMealLog != null) {
        setState(() {
          mealLogDetailData = updatedMealLog;
          recipeSummaryDataList?.removeAt(index);
        });
      } else {
        throw Exception('Failed to update meal log');
      }
    } catch (e) {
      debugPrint('Error removing recipe: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to remove recipe. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (mealLogDetailData != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: NutrientsProgressSection(
                  mealLogDetailData: mealLogDetailData!),
            ),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              'YOU HAVE TRACKED',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
                fontSize: 14.sp,
              ),
            ),
          ),
          Expanded(
            child: recipeSummaryDataList != null &&
                    recipeSummaryDataList!.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: recipeSummaryDataList!.length,
                    itemBuilder: (context, index) {
                      final recipe = recipeSummaryDataList![index];
                      return RecipeItemCard(
                        recipe: recipe,
                        onRemove: () => _handleRemoveRecipe(recipe),
                      );
                    },
                  )
                : Center(
                    child: Text(
                      'No recipes tracked yet',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
