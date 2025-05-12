import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecipeSearchBar extends StatefulWidget {
  final Function(bool) onSearchFocusChanged;
  final Function(String) onSearchTextChanged;

  const RecipeSearchBar({
    super.key,
    required this.onSearchFocusChanged,
    required this.onSearchTextChanged,
  });

  @override
  State<RecipeSearchBar> createState() => _RecipeSearchBarState();
}

class _RecipeSearchBarState extends State<RecipeSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F0ED),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          SizedBox(width: 8.w),
          Expanded(
            child: Focus(
              onFocusChange: widget.onSearchFocusChanged,
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Food, meal or brand',
                  border: InputBorder.none,
                  isDense: true,
                ),
                style: TextStyle(fontSize: 16.sp),
                onChanged: widget.onSearchTextChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
