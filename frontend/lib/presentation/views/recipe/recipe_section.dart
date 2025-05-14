import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutriai_app/data/models/recipe_summary_data.dart'
    // ignore: library_prefixes
    show
        RecipeSummaryData;
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
  State<RecipeSection> createState() => _RecipeSectionState();
}

class _RecipeSectionState extends State<RecipeSection> {
  List<RecipeSummaryData> recipeSummaryList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    if (!mounted) return;
    try {
      final recipeSummaryList = await RecipeService()
          .fetchRecipeSummaryListByMealTime(
              mealTime: widget.title, pageNumber: 0, pageSize: 5);
      if (mounted) {
        setState(() {
          this.recipeSummaryList = recipeSummaryList;
        });
      }
    } catch (e) {
      debugPrint('❌ Error fetching recipes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (recipeSummaryList.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 18.sp,
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
        SizedBox(height: 4.w),
        SizedBox(
          height: 220.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            itemCount: recipeSummaryList.length,
            itemBuilder: (context, index) => SizedBox(
              width: 160.w,
              child: RecipeCard(
                recipeSummaryData: recipeSummaryList[index],
              ),
            ),
            separatorBuilder: (context, index) => SizedBox(width: 8.w),
            physics: const ClampingScrollPhysics(),
          ),
        ),
      ],
    );
  }
}
