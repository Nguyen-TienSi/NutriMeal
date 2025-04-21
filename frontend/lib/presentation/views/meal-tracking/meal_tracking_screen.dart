import 'package:flutter/material.dart';
import 'barcode_scan_icon.dart' show BarcodeScanIcon;
import 'food_search_bar.dart' show FoodSearchBar;
import 'macronutrients_progress_section.dart'
    show MacronutrientsProgressSection;

import 'food_item_card.dart' show FoodItemCard;

class MealTrackingScreen extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> trackedFoods = [
    {
      'title': 'Banana',
      'calories': 93,
      'carbs': 24,
      'protein': 1,
      'fat': 0,
    },
    {
      'title': 'Oatmeal',
      'calories': 227,
      'carbs': 32,
      'protein': 5,
      'fat': 2,
    },
    {
      'title': 'Apple',
      'calories': 80,
      'carbs': 22,
      'protein': 0,
      'fat': 0,
    },
  ];

  MealTrackingScreen({super.key, required this.title});

  @override
  State<MealTrackingScreen> createState() => _State();
}

class _State extends State<MealTrackingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: FoodSearchBar()),
                  const SizedBox(width: 8),
                  BarcodeScanIcon(
                    onScanPressed: () {
                      debugPrint('Barcode scan pressed');
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: MacronutrientsProgressSection(),
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
            Expanded(
              child: ListView.builder(
                itemCount: widget.trackedFoods.length,
                itemBuilder: (context, index) {
                  final food = widget.trackedFoods[index];
                  return FoodItemCard(
                    title: food['title'],
                    calories: food['calories'],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'DONE',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
