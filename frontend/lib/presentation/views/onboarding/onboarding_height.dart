import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nutriai_app/data/models/user_create_data.dart';

class OnboardingHeight extends StatefulWidget {
  final UserCreateData userCreateData;
  const OnboardingHeight({super.key, required this.userCreateData});

  @override
  State<OnboardingHeight> createState() => _OnboardingHeightState();
}

class _OnboardingHeightState extends State<OnboardingHeight> {
  late final TextEditingController _cmController;

  @override
  void initState() {
    super.initState();
    widget.userCreateData.currentHeight = 170;
    _cmController = TextEditingController(
      text: widget.userCreateData.currentHeight.toString(),
    );
    _cmController.addListener(_onHeightChanged);
  }

  void _onHeightChanged() {
    final text = _cmController.text;
    final height = int.tryParse(text);
    setState(() {
      widget.userCreateData.currentHeight = height;
    });
  }

  @override
  void dispose() {
    _cmController.removeListener(_onHeightChanged);
    _cmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "What is your height?",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          const Text(
            "Enter your height in centimeters",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          _heightInputField(
            heightController: _cmController,
            heightUnit: "cm",
            maxLength: 3,
          ),
        ],
      ),
    );
  }

  Widget _heightInputField({
    required TextEditingController heightController,
    required String heightUnit,
    required int maxLength,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
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
                const TextStyle(fontSize: 56, fontWeight: FontWeight.bold),
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
                    isDense: true,
                  ),
                  style: const TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    letterSpacing: -1,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(maxLength),
                  ],
                ),
              );
            },
          ),
          const SizedBox(width: 12),
          Text(
            heightUnit,
            style: const TextStyle(
              fontSize: 24,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.5,
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
