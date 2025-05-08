import 'package:flutter/material.dart';
import 'package:nutriai_app/presentation/views/recipe/recipe_detail_screen.dart';
import 'package:uuid/uuid_value.dart';
import 'package:nutriai_app/data/models/recipe_summary_data.dart';
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
  String _searchText = '';
  final GlobalKey<NutritionalInfoSectionState> _nutritionalInfoKey =
      GlobalKey();

  void _handleSearchFocusChanged(bool hasFocus) {
    setState(() {
      _isSearching = hasFocus;
    });
  }

  void _handleSearchTextChanged(String text) {
    setState(() {
      _searchText = text;
    });
  }

  void _handleRecipeSelected(RecipeSummaryData recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetailScreen(
          id: recipe.id!,
          mealLogId: widget.mealLogId,
        ),
      ),
    ).then((_) {
      // Refresh nutritional info section after returning from recipe detail
      _nutritionalInfoKey.currentState?.fetchData();
    });
    setState(() {
      _isSearching = false;
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
                      onSearchTextChanged: _handleSearchTextChanged,
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
                  ? SearchRecipeSection(
                      value: _searchText,
                      onRecipeSelected: _handleRecipeSelected,
                      mealLogId: widget.mealLogId,
                    )
                  : NutritionalInfoSection(
                      key: _nutritionalInfoKey,
                      mealLogId: widget.mealLogId,
                    ),
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
