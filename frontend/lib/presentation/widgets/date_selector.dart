import 'package:flutter/material.dart';

class DateSelector extends StatelessWidget {
  const DateSelector({super.key});

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
              const Text(
                "March 2025",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () {}, // TODO: Thêm logic chọn ngày
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              return Column(
                children: [
                  Text(
                    ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"][index],
                    style: const TextStyle(fontSize: 14),
                  ),
                  CircleAvatar(
                    backgroundColor:
                        index == 4 ? Colors.green : Colors.transparent,
                    child: Text("${24 + index}"),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
