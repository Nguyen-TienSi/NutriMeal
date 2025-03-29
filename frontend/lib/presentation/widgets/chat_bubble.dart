import 'package:flutter/material.dart';

/// **Widget hiển thị hộp thoại chat với AI**
class ChatBubble extends StatelessWidget {
  final String message;
  final bool isAI;

  const ChatBubble({required this.message, this.isAI = true, super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isAI ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth:
              MediaQuery.of(context).size.width * 0.75, // Giới hạn chiều rộng
        ),
        decoration: BoxDecoration(
          color: isAI ? Colors.blue[600] : Colors.green[600],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft:
                isAI ? const Radius.circular(0) : const Radius.circular(12),
            bottomRight:
                isAI ? const Radius.circular(12) : const Radius.circular(0),
          ),
        ),
        child: Text(
          message,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
