import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BarcodeScanIcon extends StatelessWidget {
  final void Function()? onScanPressed;

  const BarcodeScanIcon({super.key, this.onScanPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onScanPressed,
      child: Container(
        height: 44.h,
        width: 44.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.green),
        ),
        child: IconButton(
          icon: const Icon(Icons.qr_code_scanner, color: Colors.green),
          onPressed: () {},
        ),
      ),
    );
  }
}
