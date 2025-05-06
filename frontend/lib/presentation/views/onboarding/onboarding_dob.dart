import 'package:flutter/material.dart';
import 'package:nutriai_app/data/models/user_create_data.dart';

class OnboardingDob extends StatefulWidget {
  final UserCreateData userCreateData;

  const OnboardingDob({super.key, required this.userCreateData});

  @override
  State<OnboardingDob> createState() => _OnboardingDobState();
}

class _OnboardingDobState extends State<OnboardingDob> {
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

  final List<String> years = List.generate(
      DateTime.now().year - 1990 + 1, (index) => (1990 + index).toString());

  String? selectedMonth;
  String? selectedDay;
  String? selectedYear;
  List<String> days = [];

  List<String> _generateDays(String? selectedMonth, String? selectedYear) {
    if (selectedMonth == null || selectedYear == null) return [];

    int monthIndex = months.indexOf(selectedMonth) + 1;
    int year = int.parse(selectedYear);

    int daysInMonth = DateTime(year, monthIndex + 1, 0).day;

    return List.generate(daysInMonth, (index) => (index + 1).toString());
  }

  void _updateDateOfBirth() {
    if (selectedMonth != null && selectedDay != null && selectedYear != null) {
      widget.userCreateData.dateOfBirth = DateTime(
        int.parse(selectedYear!),
        months.indexOf(selectedMonth!) + 1,
        int.parse(selectedDay!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "What is your date of birth?",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        const Text(
          "Select your date of birth",
          style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 48),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildPopupMenuButton(
              hint: "Year",
              selectedValue: selectedYear,
              items: years,
              onSelected: (value) {
                setState(() {
                  selectedYear = value;
                  days = _generateDays(selectedMonth, selectedYear);
                  if (selectedDay != null &&
                      int.parse(selectedDay!) > days.length) {
                    selectedDay = null;
                  }
                  _updateDateOfBirth();
                });
              },
            ),
            _buildPopupMenuButton(
              hint: "Month",
              selectedValue: selectedMonth,
              items: months,
              onSelected: (value) {
                setState(() {
                  selectedMonth = value;
                  days = _generateDays(selectedMonth, selectedYear);
                  if (selectedDay != null &&
                      int.parse(selectedDay!) > days.length) {
                    selectedDay = null;
                  }
                  _updateDateOfBirth();
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
                  _updateDateOfBirth();
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
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(
              color: selectedValue != null ? Colors.green : Colors.grey),
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            const BoxShadow(
              color: Colors.black12,
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Text(selectedValue ?? hint,
            style: TextStyle(
                color: selectedValue != null ? Colors.black87 : Colors.black54,
                fontSize: 18,
                fontWeight: FontWeight.w500)),
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
