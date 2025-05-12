import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutriai_app/data/models/user_detail_data.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class WeightGaugeChart extends StatelessWidget {
  final UserDetailData userDetailData;

  const WeightGaugeChart({super.key, required this.userDetailData});

  @override
  Widget build(BuildContext context) {
    final minWeight = userDetailData.currentWeight!;
    final maxWeight = userDetailData.targetWeight!;

    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          minimum: minWeight.toDouble(),
          maximum: maxWeight.toDouble(),
          radiusFactor: 0.93.r,
          showTicks: false,
          showLabels: false,
          axisLineStyle: AxisLineStyle(
            thickness: 0.15,
            thicknessUnit: GaugeSizeUnit.factor,
            cornerStyle: CornerStyle.bothCurve,
            gradient: SweepGradient(
              colors: [
                const Color(0xFF3887FD),
                const Color(0xFF6EC6FF),
                const Color(0xFF3887FD),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          pointers: <GaugePointer>[
            MarkerPointer(
              value: userDetailData.currentWeight!.toDouble(),
              markerType: MarkerType.circle,
              markerHeight: 24.sp,
              markerWidth: 24.sp,
              color: Colors.tealAccent.shade700,
              borderWidth: 6.sp,
              borderColor: Colors.white,
              enableAnimation: true,
              animationDuration: 1200,
              elevation: 8,
            ),
          ],
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
              widget: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    // Current Weight
                    'Current Weight',
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    // Current Weight Value
                    '${userDetailData.currentWeight} kg',
                    style: TextStyle(
                      fontSize: 48.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3887FD),
                      letterSpacing: 1.2,
                    ).copyWith(fontSize: 48.sp),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            // Min Weight Label
                            'Min',
                            style: TextStyle(
                                fontSize: 18.sp,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            '${minWeight} kg',
                            style: TextStyle(
                                fontSize: 18.sp, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(width: 20.w),
                      Column(
                        children: [
                          Text(
                            // Max Weight Label
                            'Max',
                            style: TextStyle(
                                // Max Weight Label
                                fontSize: 18.sp,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            '${maxWeight} kg',
                            style: TextStyle(
                                fontSize: 18.sp, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              angle: 90,
              positionFactor: 0.0,
            ),
          ],
        ),
      ],
    );
  }
}
