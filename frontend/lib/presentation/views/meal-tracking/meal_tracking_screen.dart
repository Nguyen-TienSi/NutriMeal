import 'package:flutter/material.dart';
import 'package:uuid/uuid_value.dart';
import 'barcode_scan_icon.dart';
import 'nutritional_info_section.dart';
import 'recipe_search_bar.dart';
import 'search_recipe_section.dart';

class MealTrackingScreen extends StatefulWidget {
  final String title;

  final UuidValue mealLogId;

  const MealTrackingScreen(
      {super.key, required this.title, required this.mealLogId});

  @override
  State<MealTrackingScreen> createState() => _MealTrackingScreenState();
}

class _MealTrackingScreenState extends State<MealTrackingScreen> {
  bool _isSearching = false;

  void _handleSearchFocusChanged(bool hasFocus) {
    setState(() {
      _isSearching = hasFocus;
    });
  }

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
                  Expanded(
                    child: RecipeSearchBar(
                      onSearchFocusChanged: _handleSearchFocusChanged,
                    ),
                  ),
                  const SizedBox(width: 8),
                  BarcodeScanIcon(
                    onScanPressed: () {
                      debugPrint('Barcode scan pressed');
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: _isSearching
                  ? const SearchRecipeSection()
                  : NutritionalInfoSection(mealLogId: widget.mealLogId),
            ),
            if (!_isSearching)
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
