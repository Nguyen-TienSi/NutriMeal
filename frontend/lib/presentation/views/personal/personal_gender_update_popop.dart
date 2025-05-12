import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutriai_app/utils/enums.dart';

class PersonalGenderUpdatePopup extends StatefulWidget {
  final Gender? currentGender;
  final ValueChanged<Gender> onSave;

  const PersonalGenderUpdatePopup({
    super.key,
    required this.currentGender,
    required this.onSave,
  });

  @override
  State<PersonalGenderUpdatePopup> createState() =>
      _PersonalGenderUpdatePopupState();
}

class _PersonalGenderUpdatePopupState extends State<PersonalGenderUpdatePopup> {
  late Gender? _selectedGender;

  @override
  void initState() {
    super.initState();
    _selectedGender = widget.currentGender;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update Gender'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: Gender.values.map((gender) {
          return RadioListTile<Gender>(
            value: gender,
            groupValue: _selectedGender,
            title: Text(
              _genderString(gender),
              style: TextStyle(fontSize: 16.sp),
            ),
            onChanged: (value) {
              setState(() {
                _selectedGender = value;
              });
            },
          );
        }).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: TextStyle(fontSize: 16.sp),
          ),
        ),
        ElevatedButton(
          onPressed: _selectedGender == null
              ? null
              : () {
                  widget.onSave(_selectedGender!);
                  Navigator.pop(context);
                },
          child: const Text('Save'),
        ),
      ],
    );
  }

  String _genderString(Gender gender) {
    switch (gender) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
      case Gender.other:
        return 'Other';
    }
  }
}
