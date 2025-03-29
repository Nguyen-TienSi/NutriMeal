import 'package:flutter/material.dart';

import '../../widgets/chat_bubble.dart';
import '../../widgets/chat_input_field.dart';
import '../../widgets/question_suggestion.dart';

class AskAIScreen extends StatelessWidget {
  const AskAIScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(top: 10),
                children: const [
                  ChatBubble(
                    message:
                        "Hi Tien Si Nguyen, I am your smart dietitian assistant. "
                        "I can answer any questions related to your diet and health.",
                    isAI: true,
                  ),
                  ChatBubble(
                    message: "How can I lose weight quickly?",
                    isAI: false,
                  ),
                  ChatBubble(
                    message:
                        "It's important to focus on a healthy diet and exercise.",
                    isAI: true,
                  ),
                ],
              ),
            ),
            const QuestionSuggestions(),
            const ChatInputField(),
          ],
        ),
      ),
    );
  }
}
