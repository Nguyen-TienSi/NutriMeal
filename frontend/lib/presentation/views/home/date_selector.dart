import 'package:flutter/material.dart';

class DateSelector extends StatefulWidget {
  const DateSelector({super.key});

  @override
  State<DateSelector> createState() => _State();
}

class _State extends State<DateSelector> {
  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () => _selectDate(context),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              DateTime day = _selectedDate
                  .add(Duration(days: index - (_selectedDate.weekday - 1)));
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDate = day;
                  });
                },
                child: Column(
                  children: [
                    Text(
                      ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"][index],
                      style: const TextStyle(fontSize: 14),
                    ),
                    CircleAvatar(
                      backgroundColor: day.day == _selectedDate.day &&
                              day.month == _selectedDate.month &&
                              day.year == _selectedDate.year
                          ? Colors.green
                          : Colors.transparent,
                      child: Text("${day.day}"),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
