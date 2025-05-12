import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isAI;

  const ChatBubble({required this.message, this.isAI = true, super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isAI ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        padding: EdgeInsets.all(12.w),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75.w,
        ),
        decoration: BoxDecoration(
          color: isAI ? Colors.blue[600] : Colors.green[600],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.r),
            topRight: Radius.circular(12.r),
            bottomLeft: isAI ? Radius.circular(0.r) : Radius.circular(12.r),
            bottomRight: isAI ? Radius.circular(12.r) : Radius.circular(0.r),
          ),
        ),
        child: Text(
          message,
          style: TextStyle(color: Colors.white, fontSize: 16.sp),
        ),
      ),
    );
  }
}
