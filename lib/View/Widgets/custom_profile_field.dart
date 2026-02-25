// ignore_for_file: deprecated_member_use

import 'package:floraheart/config/Colors/colors.dart';
import 'package:flutter/material.dart';

class CustomProfileField extends StatefulWidget {
  final String? label;
  final String hintText;
  final bool isPassword; // optional password

  const CustomProfileField({
    super.key,
    this.label,
    required this.hintText,
    this.isPassword = false, // default false
  });

  @override
  State<CustomProfileField> createState() => _CustomProfileFieldState();
}

class _CustomProfileFieldState extends State<CustomProfileField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Show label only if not null
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
        ],

        /// Text Field (Always visible)
        SizedBox(
          height: 50,
          child: TextFormField(
            obscureText: widget.isPassword ? _obscureText : false,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(
                color: AppColors.grey,
                fontSize: 13,
              ),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 14,
              ),

              /// Show suffix icon only if password
              suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: Icon(
                        _obscureText
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                  : null,

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: AppColors.grey.withOpacity(0.3),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: AppColors.grey.withOpacity(0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}