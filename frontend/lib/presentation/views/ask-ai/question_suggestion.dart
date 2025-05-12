import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'suggestion_button.dart';

class QuestionSuggestions extends StatelessWidget {
  const QuestionSuggestions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        children: [
          Expanded(
            child: SuggestionButton(
                text: "What should I do to reach my target weight fast?"),
          ),
          SizedBox(width: 8),
          Expanded(
            child: SuggestionButton(
                text:
                    "Based on my diet goals, what should I add to the food in this photo?"),
          ),
        ],
      ),
    );
  }
}
