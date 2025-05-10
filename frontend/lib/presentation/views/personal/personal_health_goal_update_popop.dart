import 'package:flutter/material.dart';
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
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _selectedGoal == null
              ? null
              : () {
                  widget.onSave(_selectedGoal!);
                  Navigator.of(context).pop();
                },
          child: const Text('Save'),
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
