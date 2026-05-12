import 'package:floraheart/config/Colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTextFormField extends StatefulWidget {
  final String? label;
  final String hintText;
  final bool isPassword;
  final TextEditingController controller;

  const CustomTextFormField({
    super.key,
    this.label,
    required this.hintText,
    required this.controller,
    this.isPassword = false,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  final RxBool _obscureText = true.obs;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Show label only if not null
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8),

          /// TextField
          Obx(() {
            final obscure = _obscureText.value;
            return TextFormField(
              controller: widget.controller,
              obscureText: widget.isPassword ? obscure : false,
              decoration: InputDecoration(
                hintText: widget.hintText,
                filled: true,
                fillColor: AppColors.lightgrey,

                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                    width: 1.5,
                  ),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  borderSide: const BorderSide(color: Colors.red, width: 1.5),
                ),

                suffixIcon: widget.isPassword
                    ? IconButton(
                        icon: Icon(
                          obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        ),
                        onPressed: () {
                          _obscureText.toggle();
                        },
                      )
                    : null,
              ),
            );
          }),
        ],
      ],
    );
  }
}
