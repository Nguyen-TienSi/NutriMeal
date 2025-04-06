import 'package:flutter/material.dart';

import 'calories_chart.dart';
import 'date_selector.dart';
import 'meal_card.dart';
import 'nutrition_info.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DateSelector(),
              const SizedBox(height: 20),
              const Text(
                "Today calories",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const CaloriesChart(
                calories: 1564,
                goalCalories: 2000,
              ),
              const SizedBox(height: 20),
              const NutritionInfo(carbs: 241, protein: 250, fat: 50),
              const SizedBox(height: 40),

              // Danh sách bữa ăn
              IntrinsicHeight(
                child: Column(
                  children: [
                    MealCard(
                      mealName: "Breakfast",
                      kcalRange: "401 - 601",
                      imagePath: "assets/images/breakfast.jpg",
                      onTap: () => print("Add Breakfast"),
                    ),
                    MealCard(
                      mealName: "Lunch",
                      kcalRange: "601 - 801",
                      imagePath: "assets/images/lunch.jpg",
                      onTap: () => print("Add Lunch"),
                    ),
                    MealCard(
                      mealName: "Dinner",
                      kcalRange: "601 - 801",
                      imagePath: "assets/images/dinner.jpg",
                      onTap: () => print("Add Dinner"),
                    ),
                    MealCard(
                      mealName: "Snacks",
                      kcalRange: "100 - 200",
                      imagePath: "assets/images/snacks.jpg",
                      onTap: () => print("Add Snacks"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
