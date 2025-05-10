import 'package:flutter/material.dart';

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
      title: const Text('Update Name'),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: 'Name',
          errorText: _error,
        ),
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _handleSave,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
