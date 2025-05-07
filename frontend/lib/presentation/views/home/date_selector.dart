import 'package:flutter/material.dart';

class DateSelector extends StatefulWidget {
  final Function(DateTime) onDateChanged;
  final DateTime initialDate;

  const DateSelector({
    super.key,
    required this.onDateChanged,
    required this.initialDate,
  });

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  @override
  void didUpdateWidget(DateSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialDate != widget.initialDate) {
      _selectedDate = widget.initialDate;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      _updateState(picked);
    }
  }

  void _updateState(DateTime date) {
    if (mounted) {
      setState(() {
        _selectedDate = date;
      });
      widget.onDateChanged(date);
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
                onTap: () => _updateState(day),
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
