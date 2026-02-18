import 'package:floraheart/config/Colors/colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? ontap;
  const CustomButton({super.key, required this.label, this.ontap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
        onPressed: ontap,
        child: Text(
          label,
          style: TextStyle(color: AppColors.white, fontSize: 16),
        ),
      ),
    );
  }
}
