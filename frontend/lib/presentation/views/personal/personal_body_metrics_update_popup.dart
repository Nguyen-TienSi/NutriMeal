import 'package:flutter/material.dart';

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
      title: Text('Update ${widget.label}'),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: '${widget.label} (${widget.unit})',
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
