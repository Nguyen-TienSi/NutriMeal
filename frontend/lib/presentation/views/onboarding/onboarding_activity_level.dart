import 'package:flutter/material.dart';
import 'package:nutriai_app/data/models/user_create_data.dart';
import 'package:nutriai_app/utils/enums.dart';

class OnboardingActivityLevel extends StatefulWidget {
  final UserCreateData userCreateData;
  const OnboardingActivityLevel({super.key, required this.userCreateData});

  @override
  State<OnboardingActivityLevel> createState() =>
      _OnboardingActivityLevelState();
}

class _OnboardingActivityLevelState extends State<OnboardingActivityLevel> {
  ActivityLevel? _selectedActivityLevel;

  @override
  void initState() {
    super.initState();
    _selectedActivityLevel = widget.userCreateData.activityLevel;
  }

  void _onActivityLevelSelected(ActivityLevel level) {
    setState(() {
      _selectedActivityLevel = level;
      widget.userCreateData.activityLevel = level;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "How active are you?",
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
            "Select your daily activity level",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          _buildActivityLevelOptions(),
        ],
      ),
    );
  }

  Widget _buildActivityLevelOptions() {
    return Column(
      children: [
        _buildActivityLevelCard(
          level: ActivityLevel.unActive,
          title: "Not Very Active",
          description: "Little to no exercise, desk job",
          icon: Icons.sentiment_dissatisfied,
        ),
        const SizedBox(height: 16),
        _buildActivityLevelCard(
          level: ActivityLevel.normal,
          title: "Moderately Active",
          description: "Light exercise 1-3 days/week",
          icon: Icons.sentiment_neutral,
        ),
        const SizedBox(height: 16),
        _buildActivityLevelCard(
          level: ActivityLevel.active,
          title: "Very Active",
          description: "Hard exercise 3-5 days/week",
          icon: Icons.sentiment_very_satisfied,
        ),
      ],
    );
  }

  Widget _buildActivityLevelCard({
    required ActivityLevel level,
    required String title,
    required String description,
    required IconData icon,
  }) {
    final isSelected = _selectedActivityLevel == level;

    return GestureDetector(
      onTap: () => _onActivityLevelSelected(level),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor.withValues(alpha: 26)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey.shade200,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.black54,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
