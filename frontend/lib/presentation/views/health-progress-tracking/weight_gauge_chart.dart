import 'package:flutter/material.dart';
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
          radiusFactor: 0.8,
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
              markerHeight: 24,
              markerWidth: 24,
              color: Colors.tealAccent.shade700,
              borderWidth: 6,
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
                    'Current Weight',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${userDetailData.currentWeight} kg',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3887FD),
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Min',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${minWeight}kg',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Column(
                        children: [
                          Text(
                            'Max',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${maxWeight}kg',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
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
