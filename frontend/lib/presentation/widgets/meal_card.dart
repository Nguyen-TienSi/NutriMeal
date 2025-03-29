import 'package:flutter/material.dart';

class MealCard extends StatelessWidget {
  final String mealName;
  final String kcalRange;
  final String imagePath;
  final VoidCallback onTap;

  const MealCard({
    super.key,
    required this.mealName,
    required this.kcalRange,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white60,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading:
            Image.asset(imagePath, width: 50, height: 50, fit: BoxFit.cover),
        title: Text(
          mealName,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "Recommended $kcalRange kcal",
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        trailing: IconButton(
          icon: const Icon(
            Icons.add_circle_outline,
            color: Colors.grey,
            size: 30,
          ),
          onPressed: onTap,
        ),
      ),
    );
  }
}
