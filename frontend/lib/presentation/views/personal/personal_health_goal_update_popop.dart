import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutriai_app/utils/enums.dart';

class PersonalHealthGoalUpdatePopup extends StatefulWidget {
  final HealthGoal? currentGoal;
  final ValueChanged<HealthGoal> onSave;

  const PersonalHealthGoalUpdatePopup({
    super.key,
    required this.currentGoal,
    required this.onSave,
  });

  @override
  State<PersonalHealthGoalUpdatePopup> createState() =>
      _PersonalHealthGoalUpdatePopupState();
}

class _PersonalHealthGoalUpdatePopupState
    extends State<PersonalHealthGoalUpdatePopup> {
  late HealthGoal? _selectedGoal;

  @override
  void initState() {
    super.initState();
    _selectedGoal = widget.currentGoal;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 10.h),
      titlePadding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 0),
      actionsPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      title: const Text('Update Health Goal'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: HealthGoal.values.map((goal) {
          return RadioListTile<HealthGoal>(
            value: goal,
            groupValue: _selectedGoal,
            title: Text(_goalString(goal)),
            onChanged: (value) {
              setState(() {
                _selectedGoal = value;
              });
            },
          );
        }).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel', style: TextStyle(fontSize: 14.sp)),
        ),
        ElevatedButton(
          onPressed: _selectedGoal == null
              ? null
              : () {
                  widget.onSave(_selectedGoal!);
                  Navigator.of(context).pop();
                },
          child: Text('Save', style: TextStyle(fontSize: 14.sp)),
        ),
      ],
    );
  }

  String _goalString(HealthGoal goal) {
    switch (goal) {
      case HealthGoal.weightLoss:
        return 'Lose weight';
      case HealthGoal.weightGain:
        return 'Gain weight';
      case HealthGoal.maintain:
        return 'Maintain weight';
    }
  }
}
