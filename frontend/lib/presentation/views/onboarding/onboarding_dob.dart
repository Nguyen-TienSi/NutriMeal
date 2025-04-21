import 'package:flutter/material.dart';

class OnboardingDob extends StatefulWidget {
  const OnboardingDob({super.key});

  @override
  State<OnboardingDob> createState() => _State();
}

class _State extends State<OnboardingDob> {
  String? selectedMonth;
  String? selectedDay;
  String? selectedYear;

  final List<String> months = [
    'JAN',
    'FEB',
    'MAR',
    'APR',
    'MAY',
    'JUN',
    'JUL',
    'AUG',
    'SEP',
    'OCT',
    'NOV',
    'DEC'
  ];

  late final List<String> years;
  List<String> days = [];

  @override
  void initState() {
    super.initState();
    final int totalYearsSince1990 = DateTime.now().year - 1990 + 1;
    years = List.generate(
        totalYearsSince1990, (index) => (1990 + index).toString());
  }

  void _updateDays() {
    if (selectedMonth == null || selectedYear == null) return;

    int monthIndex = months.indexOf(selectedMonth!) + 1;
    int year = int.parse(selectedYear!);

    int daysInMonth = DateTime(year, monthIndex + 1, 0).day;

    setState(() {
      days = List.generate(daysInMonth, (index) => (index + 1).toString());

      if (selectedDay != null && int.parse(selectedDay!) > daysInMonth) {
        selectedDay = null;
      }
    });
  }

  bool _isSelectedDobValid() =>
      selectedMonth != null && selectedDay != null && selectedYear != null;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildPopupMenuButton(
              hint: "Month",
              selectedValue: selectedMonth,
              items: months,
              onSelected: (value) {
                setState(() {
                  selectedMonth = value;
                  _updateDays();
                });
              },
            ),
            _buildPopupMenuButton(
              hint: "Year",
              selectedValue: selectedYear,
              items: years,
              onSelected: (value) {
                setState(() {
                  selectedYear = value;
                  _updateDays();
                });
              },
            ),
            _buildPopupMenuButton(
              hint: "Day",
              selectedValue: selectedDay,
              items: days,
              onSelected: (value) {
                setState(() {
                  selectedDay = value;
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPopupMenuButton({
    required String hint,
    required String? selectedValue,
    required List<String> items,
    required ValueChanged<String> onSelected,
  }) {
    return PopupMenuButton<String>(
      onSelected: onSelected,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          border: Border.all(
              color: selectedValue != null ? Colors.green : Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child:
            Text(selectedValue ?? hint, style: TextStyle(color: Colors.black)),
      ),
      itemBuilder: (BuildContext context) {
        return items.map((String value) {
          return PopupMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList();
      },
    );
  }
}
