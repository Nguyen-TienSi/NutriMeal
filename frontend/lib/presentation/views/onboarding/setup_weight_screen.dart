import 'package:flutter/material.dart';

class OnboardingWeightScreen extends StatefulWidget {
  const OnboardingWeightScreen({super.key});

  @override
  State<OnboardingWeightScreen> createState() => _State();
}

class _State extends State<OnboardingWeightScreen> {
  double _currentWeight = 50;
  bool _isLbs = true;

  void _toggleUnit(bool isLbs) {
    setState(() {
      _isLbs = isLbs;
      _currentWeight = isLbs ? _currentWeight * 2.205 : _currentWeight / 2.205;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: Navigator.of(context).pop,
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: LinearProgressIndicator(
          value: 0.5,
          backgroundColor: Colors.grey[300],
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "What is your weight?",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Image.asset("assets/images/scale.png"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _unitButton("lbs", _isLbs),
                const SizedBox(width: 20),
                _unitButton("kg", !_isLbs),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _unitButton(String unit, bool isSelected) {
    return GestureDetector(
      onTap: () => _toggleUnit(unit == "lbs"),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey,
            width: 2.0,
          ),
        ),
        child: Text(
          unit,
          style: TextStyle(
            fontSize: 18,
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
