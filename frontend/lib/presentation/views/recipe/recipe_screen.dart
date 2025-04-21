import 'package:flutter/material.dart';
import 'recipe_section.dart' show RecipeSection;
import 'recipe_grid_screen.dart' show DishGridScreen;

class RecipeScreen extends StatelessWidget {
  const RecipeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              RecipeSection(
                title: 'Breakfast',
                onSeeAllPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DishGridScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              RecipeSection(
                title: 'Lunch',
                onSeeAllPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DishGridScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              RecipeSection(
                title: 'Dinner',
                onSeeAllPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DishGridScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              RecipeSection(
                title: 'Snacks',
                onSeeAllPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DishGridScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
