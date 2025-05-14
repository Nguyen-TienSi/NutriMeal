import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutriai_app/data/models/recipe_summary_data.dart'
    show RecipeSummaryData;
import 'package:nutriai_app/service/api-service/recipe_service.dart'
    show RecipeService;
import 'recipe_card.dart' show RecipeCard;

class DishGridScreen extends StatefulWidget {
  final String title;

  const DishGridScreen({super.key, required this.title});

  @override
  State<DishGridScreen> createState() => _DishGridScreenState();
}

class _DishGridScreenState extends State<DishGridScreen> {
  List<RecipeSummaryData> recipeSummaryList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    if (!mounted) return;
    try {
      setState(() => isLoading = true);
      final recipeSummaryList = await RecipeService()
          .fetchRecipeSummaryListByMealTime(mealTime: widget.title);
      setState(() {
        this.recipeSummaryList = recipeSummaryList;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('❌ Error fetching recipes: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (recipeSummaryList.isEmpty) {
      return const Center(child: Text('No recipes available.'));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 200.w / 250.h,
            crossAxisSpacing: 4.w,
            mainAxisSpacing: 4.h,
          ),
          padding: const EdgeInsets.all(4.0),
          itemCount: recipeSummaryList.length,
          itemBuilder: (context, index) {
            return RecipeCard(recipeSummaryData: recipeSummaryList[index]);
          },
        ),
      ),
    );
  }
}
