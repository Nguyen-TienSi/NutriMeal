import 'package:flutter/material.dart';
import 'package:nutriai_app/utils/enums.dart';

class PersonalActivityLevelUpdatePopup extends StatefulWidget {
  final ActivityLevel? currentLevel;
  final ValueChanged<ActivityLevel> onSave;

  const PersonalActivityLevelUpdatePopup({
    super.key,
    required this.currentLevel,
    required this.onSave,
  });

  @override
  State<PersonalActivityLevelUpdatePopup> createState() =>
      _PersonalActivityLevelUpdatePopupState();
}

class _PersonalActivityLevelUpdatePopupState
    extends State<PersonalActivityLevelUpdatePopup> {
  late ActivityLevel? _selectedLevel;

  @override
  void initState() {
    super.initState();
    _selectedLevel = widget.currentLevel;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update Activity Level'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: ActivityLevel.values.map((level) {
          return RadioListTile<ActivityLevel>(
            value: level,
            groupValue: _selectedLevel,
            title: Text(_activityLevelString(level)),
            onChanged: (value) {
              setState(() {
                _selectedLevel = value;
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
          onPressed: _selectedLevel == null
              ? null
              : () {
                  widget.onSave(_selectedLevel!);
                  Navigator.of(context).pop();
                },
          child: const Text('Save'),
        ),
      ],
    );
  }

  String _activityLevelString(ActivityLevel level) {
    switch (level) {
      case ActivityLevel.inActive:
        return 'Inactive';
      case ActivityLevel.normal:
        return 'Normal';
      case ActivityLevel.active:
        return 'Active';
    }
  }
}
