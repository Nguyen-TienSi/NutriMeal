import 'package:flutter/material.dart';

class OnboardingGender extends StatefulWidget {
  const OnboardingGender({super.key});

  @override
  State<OnboardingGender> createState() => _State();
}

class _State extends State<OnboardingGender> {
  String? _selectedGender;

  void _selectGender(String gender) {
    setState(() {
      _selectedGender = gender;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "What's your gender?",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _genderOption("male", "assets/images/male.png"),
            const SizedBox(width: 20),
            _genderOption("female", "assets/images/female.png"),
          ],
        ),
        const Text(
          "To give you a customer experience we need to know your gender.",
        ),
      ],
    );
  }

  Widget _genderOption(String gender, String imagePath) {
    bool isSelected = _selectedGender == gender;
    return GestureDetector(
      onTap: () => _selectGender(gender),
      child: Container(
        width: 150.0,
        height: 150.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Colors.green : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey,
            width: 2.0,
          ),
        ),
        child: Center(
          child: ClipOval(
            child: Image.asset(imagePath, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}
