import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tape_slider/tape_slider.dart';
import 'package:nutriai_app/data/models/user_create_data.dart';

class OnboardingWeight extends StatefulWidget {
  final UserCreateData userCreateData;

  const OnboardingWeight({super.key, required this.userCreateData});

  @override
  State<OnboardingWeight> createState() => _OnboardingWeightState();
}

class _OnboardingWeightState extends State<OnboardingWeight> {
  late double _currentWeight;

  void _updateWeight(double weight) {
    setState(() {
      _currentWeight = weight;
      widget.userCreateData.currentWeight = _currentWeight.round();
    });
  }

  @override
  void initState() {
    super.initState();
    _currentWeight = 50;
    widget.userCreateData.currentWeight = _currentWeight.round();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "What is your weight?",
          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        Image.asset("assets/images/scale.png", height: 200.h, width: 200.w),
        SizedBox(height: 20.h),
        Text(
          "${_currentWeight.toInt()} kg",
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: 10.h,
            horizontal: 30.w,
          ),
          child: TapeSlider(
            initialValue: _currentWeight,
            minValue: 0.0,
            maxValue: 400.0,
            onValueChanged: _updateWeight,
            activeColor: Colors.black,
            inactiveColor: Colors.black38,
            indicatorColor: Colors.green,
            itemExtent: 15.0,
            indicatorThickness: 3.0,
          ),
        ),
      ],
    );
  }
}
