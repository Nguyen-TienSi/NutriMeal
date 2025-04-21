import 'package:flutter/material.dart';

class BarcodeScanIcon extends StatelessWidget {
  final void Function()? onScanPressed;

  const BarcodeScanIcon({super.key, this.onScanPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onScanPressed,
      child: Container(
        height: 44,
        width: 44,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
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
