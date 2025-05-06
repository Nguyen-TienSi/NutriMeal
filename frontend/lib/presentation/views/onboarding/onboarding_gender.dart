import 'package:flutter/material.dart';
import 'package:nutriai_app/data/models/user_create_data.dart';
import 'package:nutriai_app/utils/enums.dart';

class OnboardingGender extends StatefulWidget {
  final UserCreateData userCreateData;

  const OnboardingGender({super.key, required this.userCreateData});

  @override
  State<OnboardingGender> createState() => _OnboardingGenderState();
}

class _OnboardingGenderState extends State<OnboardingGender> {
  Gender? _selectedGender;

  void _selectGender(Gender gender) {
    setState(() {
      _selectedGender = gender;
      widget.userCreateData.gender = gender;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _TitleText(),
          const SizedBox(height: 20),
          _GenderOptions(
            selectedGender: _selectedGender,
            onGenderSelected: _selectGender,
          ),
          const SizedBox(height: 20),
          const _DescriptionText(),
        ],
      ),
    );
  }
}

class _TitleText extends StatelessWidget {
  const _TitleText();

  @override
  Widget build(BuildContext context) {
    return const Text(
      "What's your gender?",
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }
}

class _DescriptionText extends StatelessWidget {
  const _DescriptionText();

  @override
  Widget build(BuildContext context) {
    return const Text(
      "To give you a customized experience, we need to know your gender.",
      textAlign: TextAlign.center,
    );
  }
}

class _GenderOptions extends StatelessWidget {
  final Gender? selectedGender;
  final ValueChanged<Gender> onGenderSelected;

  const _GenderOptions({
    required this.selectedGender,
    required this.onGenderSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _GenderOption(
          gender: Gender.male,
          imagePath: "assets/images/male.png",
          isSelected: selectedGender == Gender.male,
          onTap: () => onGenderSelected(Gender.male),
        ),
        const SizedBox(width: 20),
        _GenderOption(
          gender: Gender.female,
          imagePath: "assets/images/female.png",
          isSelected: selectedGender == Gender.female,
          onTap: () => onGenderSelected(Gender.female),
        ),
      ],
    );
  }
}

class _GenderOption extends StatelessWidget {
  final Gender gender;
  final String imagePath;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderOption({
    required this.gender,
    required this.imagePath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100.0,
        height: 100.0,
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
