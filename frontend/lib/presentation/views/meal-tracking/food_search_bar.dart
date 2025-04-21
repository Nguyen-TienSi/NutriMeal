import 'package:flutter/material.dart';

class FoodSearchBar extends StatelessWidget {
  const FoodSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F0ED),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Food, meal or brand',
                border: InputBorder.none,
                isDense: true,
              ),
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
