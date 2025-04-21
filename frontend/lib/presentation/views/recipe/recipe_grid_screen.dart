import 'package:flutter/material.dart';
import 'package:nutriai_app/data/models/recipe_summary_data.dart'
    show RecipeSummaryData;
import 'recipe_card.dart' show RecipeCard;

final List<RecipeSummaryData> recipes = [
  RecipeSummaryData(
    recipeName: 'Oatmeal with almonds and blueberries',
    imageUrl: 'assets/images/dish.jpg',
    calories: '227 kcal',
  ),
  RecipeSummaryData(
    recipeName: 'Grilled chicken with vegetables',
    imageUrl: 'assets/images/chicken.jpg',
    calories: '350 kcal',
  ),
  RecipeSummaryData(
    recipeName: 'Avocado toast with eggs',
    imageUrl: 'assets/images/avocado_toast.jpg',
    calories: '300 kcal',
  ),
];

class DishGridScreen extends StatefulWidget {
  const DishGridScreen({super.key});

  @override
  State<DishGridScreen> createState() => _State();
}

class _State extends State<DishGridScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 200 / 250,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
          ),
          padding: const EdgeInsets.all(4.0),
          itemCount: recipes.length,
          itemBuilder: (context, index) {
            return RecipeCard(recipeSummaryData: recipes[index]);
          },
        ),
      ),
    );
  }
}
