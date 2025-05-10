import 'package:flutter/material.dart';

class PersonalInfoCard extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onTap;
  final bool showArrow;

  const PersonalInfoCard({
    super.key,
    required this.label,
    required this.value,
    this.onTap,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (showArrow)
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Icon(Icons.chevron_right,
                      color: Colors.black26, size: 24),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
