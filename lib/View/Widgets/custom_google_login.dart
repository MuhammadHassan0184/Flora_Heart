// ignore_for_file: must_be_immutable, deprecated_member_use

import 'package:floraheart/config/Colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomGoogleLogin extends StatelessWidget {
  final String label;
  VoidCallback? onTap;
  CustomGoogleLogin({super.key, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColors.grey.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/Google.svg", width: 24, height: 24),

            SizedBox(width: 15),
            Text(label, style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
