import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutriai_app/data/models/health_tracking_detail_data.dart';
import 'package:nutriai_app/data/models/nutrient_data.dart';

class NutrientsDataTable extends StatelessWidget {
  final List<HealthTrackingDetailData> weekData;

  const NutrientsDataTable({super.key, required this.weekData});

  @override
  Widget build(BuildContext context) {
    // Prepare a map from weekday (1=Mon) to data
    final Map<int, HealthTrackingDetailData?> dayMap = {};
    for (var d in weekData) {
      dayMap[d.trackingDate.weekday] = d;
    }

    // Helper to get macro value or '-'
    String getMacro(HealthTrackingDetailData? d, String macro) {
      if (d == null) return '-';
      final n = d.consumedNutrients.firstWhere(
        (e) => e.name.toLowerCase() == macro.toLowerCase(),
        orElse: () => NutrientData(name: '', value: 0, unit: 'g'),
      );
      return n.value == 0 ? '-' : n.value.toStringAsFixed(0);
    }

    // Prepare rows for Mon–Sun
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    List<DataRow> rows = [];
    double totalCarbs = 0, totalProtein = 0, totalFat = 0;

    for (int i = 0; i < 7; i++) {
      final date = startOfWeek.add(Duration(days: i));
      final d = dayMap[date.weekday];
      final carbs = getMacro(d, 'Carbohydrate');
      final protein = getMacro(d, 'Protein');
      final fat = getMacro(d, 'Fat');
      if (carbs != '-' && protein != '-' && fat != '-') {
        totalCarbs += double.tryParse(carbs) ?? 0;
        totalProtein += double.tryParse(protein) ?? 0;
        totalFat += double.tryParse(fat) ?? 0;
      }
      rows.add(DataRow(
        cells: [
          DataCell(Text(DateFormat('E').format(date))),
          DataCell(Text(DateFormat('MMM d').format(date))),
          DataCell(Text(carbs)),
          DataCell(Text(protein)),
          DataCell(Text(fat)),
        ],
      ));
    }

    // Add total row
    rows.add(DataRow(
      cells: [
        const DataCell(
            Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
        const DataCell(Text('')),
        DataCell(Text(totalCarbs == 0 ? '-' : totalCarbs.toStringAsFixed(0))),
        DataCell(
            Text(totalProtein == 0 ? '-' : totalProtein.toStringAsFixed(0))),
        DataCell(Text(totalFat == 0 ? '-' : totalFat.toStringAsFixed(0))),
      ],
    ));

    return Card(
      margin: EdgeInsets.all(12.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Macronutrients',
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 32,
                horizontalMargin: 24,
                columns: const [
                  DataColumn(label: Text('')),
                  DataColumn(label: Text('')),
                  DataColumn(label: Text('Carbs')),
                  DataColumn(label: Text('Protein')),
                  DataColumn(label: Text('Fat')),
                ],
                rows: rows,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              '* Based on a daily macronutrient distribution of 50% carbohydrates, 25% protein, and 25% fat',
              style: TextStyle(fontSize: 12.sp, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
