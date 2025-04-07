import 'package:flutter/material.dart';

class SuggestionButton extends StatelessWidget {
  final String text;

  const SuggestionButton({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.question_answer, color: Colors.blue),
      label: Text(
        text,
        style: const TextStyle(color: Colors.blue),
      ),
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
