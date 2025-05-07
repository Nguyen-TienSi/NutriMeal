import 'package:flutter/material.dart';
import 'package:nutriai_app/data/models/meal_log_detail_data.dart';
import 'package:nutriai_app/data/models/recipe_summary_data.dart';
import 'nutrients_progress_section.dart';
import 'recipe_item_card.dart';
import 'package:nutriai_app/service/api-service/meal_log_service.dart';
import 'package:uuid/uuid_value.dart';

class NutritionalInfoSection extends StatefulWidget {
  final UuidValue mealLogId;

  const NutritionalInfoSection({super.key, required this.mealLogId});

  @override
  State<NutritionalInfoSection> createState() => _NutritionalInfoSectionState();
}

class _NutritionalInfoSectionState extends State<NutritionalInfoSection> {
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

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: mealLogDetailData != null
              ? NutrientsProgressSection(mealLogDetailData: mealLogDetailData!)
              : const SizedBox.shrink(),
        ),
        const SizedBox(height: 12),
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'YOU HAVE TRACKED',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
                fontSize: 14,
              ),
            ),
          ),
        ),
        Flexible(
          child:
              recipeSummaryDataList != null && recipeSummaryDataList!.isNotEmpty
                  ? ListView.builder(
                      itemCount: recipeSummaryDataList!.length,
                      itemBuilder: (context, index) {
                        final recipe = recipeSummaryDataList![index];
                        return RecipeItemCard(recipe: recipe);
                      },
                    )
                  : const Center(
                      child: Text(
                        'No recipes tracked yet',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
        ),
      ],
    );
  }
}
