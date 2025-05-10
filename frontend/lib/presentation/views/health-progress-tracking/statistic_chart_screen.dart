import 'package:flutter/material.dart';
import 'package:nutriai_app/data/models/health_tracking_detail_data.dart';
import 'package:nutriai_app/presentation/views/health-progress-tracking/calories_line_chart.dart';
import 'package:nutriai_app/presentation/views/health-progress-tracking/nutrients_pie_chart.dart';
import 'package:nutriai_app/presentation/views/health-progress-tracking/nutrients_data_table.dart';
import 'package:nutriai_app/service/api-service/statistic_service.dart';

class StatisticChartScreen extends StatefulWidget {
  const StatisticChartScreen({super.key});

  @override
  State<StatisticChartScreen> createState() => _StatisticChartScreenState();
}

class _StatisticChartScreenState extends State<StatisticChartScreen> {
  List<HealthTrackingDetailData> healthTrackingDetailDataList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      setState(() => isLoading = true);
      final healthTrackingDetailDataList =
          await StatisticService().getHealthTrackingDetailDataBetweenDates();
      setState(() {
        this.healthTrackingDetailDataList = healthTrackingDetailDataList;
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistic Chart'),
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CaloriesLineChart(
                      healthTrackingDetailDataList:
                          healthTrackingDetailDataList,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: NutrientsPieChart(
                      healthTrackingDetailDataList:
                          healthTrackingDetailDataList,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: NutrientsDataTable(
                        weekData: healthTrackingDetailDataList),
                  ),
                ],
              ),
      ),
    );
  }
}
