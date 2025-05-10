import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:nutriai_app/data/models/health_tracking_detail_data.dart';
import 'package:intl/intl.dart';

class CaloriesLineChart extends StatelessWidget {
  final List<HealthTrackingDetailData> healthTrackingDetailDataList;

  const CaloriesLineChart(
      {super.key, required this.healthTrackingDetailDataList});

  @override
  Widget build(BuildContext context) {
    if (healthTrackingDetailDataList.isEmpty) {
      return const Center(child: Text('No data to display'));
    }

    // Sort by date
    final sortedData =
        List<HealthTrackingDetailData>.from(healthTrackingDetailDataList)
          ..sort((a, b) => a.trackingDate.compareTo(b.trackingDate));

    // Prepare spots and labels
    final spots = <FlSpot>[];
    final labels = <String>[];
    for (int i = 0; i < sortedData.length; i++) {
      spots.add(FlSpot(i.toDouble(), sortedData[i].consumedCalories));
      labels.add(DateFormat('MM/dd').format(sortedData[i].trackingDate));
    }

    return SizedBox(
      height: 250,
      child: LineChart(
        LineChartData(
          titlesData: FlTitlesData(
            show: true,
            topTitles: AxisTitles(
              axisNameWidget: Text(
                'Calories Over Time',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              axisNameSize: 20,
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 40),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  int idx = value.toInt();
                  if (idx >= 0 && idx < labels.length) {
                    return Text(labels[idx],
                        style: const TextStyle(fontSize: 10));
                  }
                  return const SizedBox.shrink();
                },
                reservedSize: 10,
                interval: 1,
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: true),
          minX: 0,
          maxX: (spots.length - 1).toDouble(),
          minY: 0,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Colors.green,
              barWidth: 3,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
