import 'package:flutter/material.dart';
import 'recipe_section.dart' show RecipeSection;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'recipe_grid_screen.dart' show DishGridScreen;

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({super.key, this.refreshKey});

  final GlobalKey<RefreshIndicatorState>? refreshKey;

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate loading time
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                key: widget.refreshKey,
                onRefresh: () async {
                  setState(() => isLoading = true);
                  await Future.delayed(const Duration(seconds: 1));
                  if (mounted) {
                    setState(() => isLoading = false);
                  }
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      RecipeSection(
                        title: 'Breakfast',
                        onSeeAllPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DishGridScreen(title: 'Breakfast'),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 16.h),
                      RecipeSection(
                        title: 'Lunch',
                        onSeeAllPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DishGridScreen(title: 'Lunch'),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 16.h),
                      RecipeSection(
                        title: 'Dinner',
                        onSeeAllPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DishGridScreen(title: 'Dinner'),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 16.h),
                      RecipeSection(
                        title: 'Snack',
                        onSeeAllPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DishGridScreen(title: 'Snack'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
