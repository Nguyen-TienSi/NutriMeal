import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  final String buttonText;
  final String imagePath;
  final VoidCallback onPressed;

  const SocialLoginButton({
    Key? key,
    required this.buttonText,
    required this.imagePath,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 50),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            height: 24,
            width: 24,
          ),
          SizedBox(width: 8),
          Text.rich(
            TextSpan(
              text: buttonText,
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
