import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutriai_app/data/models/health_tracking_detail_data.dart';
import 'package:nutriai_app/data/models/meal_log_summary_data.dart';
import 'package:nutriai_app/data/models/nutrient_data.dart';
import 'package:nutriai_app/presentation/views/home/calories_circular_chart.dart';
import 'package:nutriai_app/presentation/views/home/date_selector.dart';
import 'package:nutriai_app/presentation/views/home/meal_log_card.dart';
import 'package:nutriai_app/presentation/views/home/nutrition_info.dart';
import 'package:nutriai_app/presentation/views/meal-tracking/meal_tracking_screen.dart';
import 'package:nutriai_app/service/api-service/health_tracking_service.dart';
import 'package:nutriai_app/service/api-service/meal_log_service.dart';
import 'package:nutriai_app/utils/enums.dart' as enums;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.refreshKey});

  final GlobalKey<RefreshIndicatorState>? refreshKey;

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
              orElse: () => NutrientData(name: name, value: 0, unit: 'grams'))
          .value ??
      0;
  double _getTotalNutrientValue(String name) =>
      healthTrackingDetailData?.totalNutrients
          .firstWhere((nutrient) => nutrient.name == name,
              orElse: () => NutrientData(name: name, value: 0, unit: 'grams'))
          .value ??
      0;
  String _getNutrientUnit(String name) =>
      healthTrackingDetailData?.consumedNutrients
          .firstWhere((nutrient) => nutrient.name == name,
              orElse: () => NutrientData(name: name, value: 0, unit: 'grams'))
          .unit ??
      '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    if (!mounted) return;
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
        child: RefreshIndicator(
          key: widget.refreshKey,
          onRefresh: fetchData,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.w),
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
                  SizedBox(height: 20.h),
                  Text(
                    "Today calories",
                    style:
                        TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20.h),
                  CaloriesCircularChart(
                    consumedCalories:
                        healthTrackingDetailData?.consumedCalories ?? 0,
                    totalCalories: healthTrackingDetailData?.totalCalories ?? 0,
                  ),
                  SizedBox(height: 20.h),
                  if (healthTrackingDetailData != null &&
                      healthTrackingDetailData!.consumedNutrients.isNotEmpty)
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          NutritionInfo(
                              nutrient: "Carbs",
                              value: _getConsumedNutrientValue("Carbohydrate"),
                              goal: _getTotalNutrientValue("Carbohydrate"),
                              unit: _getNutrientUnit("Carbohydrate")),
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
                  SizedBox(height: 40.h),
                  ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      if (mealLogSummaryData != null)
                        ...mealLogSummaryData!.map((mealLog) {
                          String mealName = switch (mealLog.timeOfDay) {
                            enums.TimeOfDay.morning => "Breakfast",
                            enums.TimeOfDay.noon => "Lunch",
                            enums.TimeOfDay.evening => "Dinner",
                            enums.TimeOfDay.afternoon ||
                            enums.TimeOfDay.night =>
                              "Snacks",
                          };
                          return MealLogCard(
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
