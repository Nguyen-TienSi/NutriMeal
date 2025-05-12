import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PersonalBodyMetricsUpdatePopup extends StatefulWidget {
  final String label;
  final int? initialValue;
  final String unit;
  final ValueChanged<int> onSave;

  const PersonalBodyMetricsUpdatePopup({
    super.key,
    required this.label,
    required this.initialValue,
    required this.unit,
    required this.onSave,
  });

  @override
  State<PersonalBodyMetricsUpdatePopup> createState() =>
      _PersonalBodyMetricsUpdatePopupState();
}

class _PersonalBodyMetricsUpdatePopupState
    extends State<PersonalBodyMetricsUpdatePopup> {
  late TextEditingController _controller;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialValue != null ? widget.initialValue.toString() : '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSave() {
    final text = _controller.text.trim();
    final value = int.tryParse(text);
    if (value == null || value <= 0) {
      setState(
          () => _error = "Please enter a valid ${widget.label.toLowerCase()}");
      return;
    }
    widget.onSave(value);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Update ${widget.label}',
        style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
      ),
      contentPadding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 10.h),
      titlePadding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 0),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: '${widget.label} (${widget.unit})',
          labelStyle: TextStyle(fontSize: 16.sp),
          errorText: _error,
          errorStyle: TextStyle(fontSize: 12.sp),
        ),
        autofocus: true,
        style: TextStyle(fontSize: 16.sp),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel', style: TextStyle(fontSize: 14.sp)),
        ),
        ElevatedButton(
          onPressed: _handleSave,
          child: Text('Save', style: TextStyle(fontSize: 14.sp)),
        ),
      ],
      actionsPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
    );
  }
}
