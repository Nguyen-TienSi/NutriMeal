import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PersonalNameUpdatePopup extends StatefulWidget {
  final String currentName;
  final ValueChanged<String> onSave;

  const PersonalNameUpdatePopup({
    super.key,
    required this.currentName,
    required this.onSave,
  });

  @override
  State<PersonalNameUpdatePopup> createState() =>
      _PersonalNameUpdatePopupState();
}

class _PersonalNameUpdatePopupState extends State<PersonalNameUpdatePopup> {
  late TextEditingController _controller;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSave() {
    final newName = _controller.text.trim();
    if (newName.isEmpty) {
      setState(() => _error = "Name can't be empty");
      return;
    }
    widget.onSave(newName);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Update Name',
        style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
      ),
      contentPadding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 10.h),
      titlePadding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 0),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: 'Name',
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
