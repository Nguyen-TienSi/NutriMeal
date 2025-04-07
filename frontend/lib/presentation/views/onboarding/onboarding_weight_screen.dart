import 'package:flutter/material.dart';
import 'package:tape_slider/tape_slider.dart';

class OnboardingWeightScreen extends StatefulWidget {
  const OnboardingWeightScreen({super.key});

  @override
  State<OnboardingWeightScreen> createState() => _OnboardingWeightScreenState();
}

class _OnboardingWeightScreenState extends State<OnboardingWeightScreen> {
  late double _currentWeight;
  late bool _isLbs;

  void _updateWeight(double weight) {
    setState(() {
      _currentWeight = weight;
    });
  }

  void _toggleUnit(String unit) {
    setState(() {
      _isLbs = (unit == "lbs" ? true : false);
      _currentWeight =
          (_isLbs ? _currentWeight * 2.205 : _currentWeight / 2.205);
    });
  }

  @override
  void initState() {
    super.initState();
    _currentWeight = 50;
    _isLbs = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  _currentWeight.toInt().toStringAsFixed(0),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 30.0,
                  ),
                  child: TapeSlider(
                    initialValue: _currentWeight,
                    minValue: 0.0,
                    maxValue: 400.0,
                    onValueChanged: _updateWeight,
                    activeColor: Colors.black,
                    inactiveColor: Colors.black38,
                    indicatorColor: Colors.black,
                    itemExtent: 15.0,
                    indicatorThickness: 3.0,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text(
                "Continue",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _unitButton(String unit, bool isSelected) {
    return GestureDetector(
      onTap: () => _toggleUnit(unit),
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
