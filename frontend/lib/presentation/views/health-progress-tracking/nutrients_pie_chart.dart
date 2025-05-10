import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:nutriai_app/data/models/health_tracking_detail_data.dart';

class NutrientsPieChart extends StatelessWidget {
  final List<HealthTrackingDetailData> healthTrackingDetailDataList;

  const NutrientsPieChart(
      {super.key, required this.healthTrackingDetailDataList});

  @override
  Widget build(BuildContext context) {
    final latest = healthTrackingDetailDataList
        .where((e) => e.consumedNutrients.isNotEmpty)
        .toList()
      ..sort((a, b) => b.trackingDate.compareTo(a.trackingDate));
    if (latest.isEmpty) {
      return const Center(child: Text('No nutrient data to display'));
    }
    final nutrients = latest.first.consumedNutrients;

    final total = nutrients.fold<double>(0, (sum, n) => sum + n.value);
    if (total == 0) {
      return const Center(child: Text('No nutrient data to display'));
    }

    final colors = [
      Colors.orange,
      Colors.blue,
      Colors.green,
      Colors.purple,
      Colors.red
    ];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Nutrient Breakdown',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: PieChart(
            PieChartData(
              sections: [
                for (int i = 0; i < nutrients.length; i++)
                  PieChartSectionData(
                    color: colors[i % colors.length],
                    value: nutrients[i].value,
                    title:
                        '${((nutrients[i].value / total) * 100).toStringAsFixed(0)}%',
                    radius: 60,
                    titleStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
              ],
              sectionsSpace: 2,
              centerSpaceRadius: 40,
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Legend
        Wrap(
          spacing: 16,
          children: [
            for (int i = 0; i < nutrients.length; i++)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    color: colors[i % colors.length],
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${nutrients[i].name} (${nutrients[i].value.toStringAsFixed(1)} ${nutrients[i].unit})',
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
