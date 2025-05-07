import 'package:flutter/material.dart';

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
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F0ED),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 8),
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
                style: const TextStyle(fontSize: 16),
                onChanged: widget.onSearchTextChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
