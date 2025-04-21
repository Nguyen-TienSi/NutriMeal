import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OnboardingHeight extends StatefulWidget {
  const OnboardingHeight({super.key});

  @override
  State<OnboardingHeight> createState() => _State();
}

class _State extends State<OnboardingHeight> {
  final TextEditingController _cmController = TextEditingController();
  final TextEditingController _feetController = TextEditingController();
  final TextEditingController _inchesController = TextEditingController();

  late bool _isCm;

  @override
  void initState() {
    super.initState();
    _isCm = true;
  }

  @override
  void dispose() {
    _cmController.dispose();
    _feetController.dispose();
    _inchesController.dispose();
    super.dispose();
  }

  void _changeHeightUnit() {
    setState(() {
      if (_isCm) {
        final cm = double.tryParse(_cmController.text) ?? 0;
        final totalInches = cm / 2.54;
        final feet = totalInches ~/ 12;
        final inches = (totalInches % 12).round();

        _feetController.text = feet.toString();
        _inchesController.text = inches.toString();
      } else {
        final feet = int.tryParse(_feetController.text) ?? 0;
        final inches = int.tryParse(_inchesController.text) ?? 0;
        final cm = feet * 30.48 + inches * 2.54;

        _cmController.text = cm.round().toString();
      }

      _isCm = !_isCm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isCm)
              _heightInputField(
                heightController: _cmController,
                heightUnit: "cm",
                maxLength: 3,
              ),
            if (!_isCm)
              Row(
                children: [
                  _heightInputField(
                    heightController: _feetController,
                    heightUnit: "feet",
                    maxLength: 2,
                  ),
                  _heightInputField(
                    heightController: _inchesController,
                    heightUnit: "inches",
                    maxLength: 2,
                  ),
                ],
              )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _changeHeightUnit,
              style: ElevatedButton.styleFrom(
                backgroundColor: !_isCm ? Colors.green : Colors.grey,
              ),
              child: Text(
                "ft/in",
                style: TextStyle(
                  color: !_isCm ? Colors.white : Colors.black,
                  fontWeight: !_isCm ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _changeHeightUnit,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isCm ? Colors.green : Colors.grey,
              ),
              child: Text(
                "cm",
                style: TextStyle(
                  color: _isCm ? Colors.white : Colors.black,
                  fontWeight: _isCm ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _heightInputField({
    required TextEditingController heightController,
    required String heightUnit,
    required int maxLength,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          AnimatedBuilder(
            animation: heightController,
            builder: (context, _) {
              final text =
                  heightController.text.isEmpty ? "0" : heightController.text;

              final textWidth = _calculateTextWidth(
                text,
                const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              );

              return SizedBox(
                width: textWidth,
                child: TextField(
                  controller: heightController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(maxLength),
                  ],
                ),
              );
            },
          ),
          Text(
            heightUnit,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  double _calculateTextWidth(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    return textPainter.width;
  }
}
