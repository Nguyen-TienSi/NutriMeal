import 'package:flutter/material.dart';
import 'package:nutriai_app/data/models/health_tracking_detail_data.dart';
import 'package:nutriai_app/data/models/meal_log_summary_data.dart';
import 'package:nutriai_app/presentation/views/meal-tracking/meal_tracking_screen.dart';
import 'package:nutriai_app/service/api-service/health_tracking_service.dart';
import 'package:nutriai_app/service/api-service/meal_log_service.dart';
import 'package:nutriai_app/utils/enums.dart' as app_enums;

import 'calories_chart.dart' show CaloriesChart;
import 'date_selector.dart' show DateSelector;
import 'meal_card.dart' show MealCard;
import 'nutrition_info.dart' show NutritionInfo;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HealthTrackingDetailData? healthTrackingDetailData;
  List<MealLogSummaryData>? mealLogSummaryData;
  bool isLoading = true;
  DateTime selectedDate = DateTime.now();

  double _getConsumedNutrientValue(String name) =>
      healthTrackingDetailData?.consumedNutrients
          .firstWhere((nutrient) => nutrient.name == name,
              orElse: () => throw Exception('Nutrient not found: $name'))
          .value ??
      0;
  double _getTotalNutrientValue(String name) =>
      healthTrackingDetailData?.totalNutrients
          .firstWhere((nutrient) => nutrient.name == name,
              orElse: () => throw Exception('Nutrient not found: $name'))
          .value ??
      0;
  String _getNutrientUnit(String name) =>
      healthTrackingDetailData?.consumedNutrients
          .firstWhere((nutrient) => nutrient.name == name,
              orElse: () => throw Exception('Nutrient not found: $name'))
          .unit ??
      '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      setState(() => isLoading = true);
      final healthTrackingData = await HealthTrackingService()
          .getHealthTrackingDetailData(selectedDate);
      final mealLogSummaryData =
          await MealLogService().getMealLogSummaryDataList(selectedDate);
      _updateState(healthTrackingData, mealLogSummaryData);
    } catch (e) {
      debugPrint(e.toString());
      _updateState(null, null);
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _updateState(HealthTrackingDetailData? healthTrackingDetailData,
      List<MealLogSummaryData>? mealLogSummaryData) {
    if (mounted) {
      setState(() {
        this.healthTrackingDetailData = healthTrackingDetailData;
        this.mealLogSummaryData = mealLogSummaryData;
      });
      debugPrint(mealLogSummaryData.toString());
      debugPrint(healthTrackingDetailData.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DateSelector(
                  initialDate: selectedDate,
                  onDateChanged: (newDate) {
                    setState(() {
                      selectedDate = newDate;
                    });
                    fetchData();
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  "Today calories",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                CaloriesChart(
                  consumedCalories:
                      healthTrackingDetailData?.consumedCalories ?? 0,
                  totalCalories: healthTrackingDetailData?.totalCalories ?? 0,
                ),
                const SizedBox(height: 20),
                if (healthTrackingDetailData != null &&
                    healthTrackingDetailData!.consumedNutrients.isNotEmpty)
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        NutritionInfo(
                            nutrient: "Carbs",
                            value: _getConsumedNutrientValue("Carbohydrates"),
                            goal: _getTotalNutrientValue("Carbohydrates"),
                            unit: _getNutrientUnit("Carbohydrates")),
                        NutritionInfo(
                            nutrient: "Protein",
                            value: _getConsumedNutrientValue("Protein"),
                            goal: _getTotalNutrientValue("Protein"),
                            unit: _getNutrientUnit("Protein")),
                        NutritionInfo(
                            nutrient: "Fat",
                            value: _getConsumedNutrientValue("Fat"),
                            goal: _getTotalNutrientValue("Fat"),
                            unit: _getNutrientUnit("Fat")),
                      ]),
                const SizedBox(height: 40),
                IntrinsicHeight(
                  child: Column(
                    children: [
                      if (mealLogSummaryData != null)
                        ...mealLogSummaryData!.map((mealLog) {
                          String mealName = switch (mealLog.timeOfDay) {
                            app_enums.TimeOfDay.morning => "Breakfast",
                            app_enums.TimeOfDay.noon => "Lunch",
                            app_enums.TimeOfDay.evening => "Dinner",
                            app_enums.TimeOfDay.afternoon ||
                            app_enums.TimeOfDay.night =>
                              "Snacks",
                          };
                          return MealCard(
                            mealName: mealName,
                            kcalRange:
                                "${mealLog.consumedCalories.toInt()} / ${mealLog.totalCalories.toInt()}",
                            imagePath:
                                "assets/images/${mealName.toLowerCase()}.jpg",
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => MealTrackingScreen(
                                    title: mealName.toUpperCase(),
                                    mealLogId: mealLog.id,
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
