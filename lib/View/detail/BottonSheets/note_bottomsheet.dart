// ignore_for_file: deprecated_member_use

import 'package:floraheart/View/Widgets/custom_button.dart';
import 'package:floraheart/config/Colors/colors.dart';
import 'package:flutter/material.dart';

class NoteBottomsheet {
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// Drag indicator
                    Container(
                      height: 4,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    SizedBox(height: 16),

                    /// Title
                    const Text(
                      "Note",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 20),

                    /// TextField Container
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.grey.withOpacity(0.3),
                        ),
                        borderRadius: BorderRadius.circular(17),
                      ),
                      child: TextField(
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: "Type Your Note..",
                          hintStyle: TextStyle(
                            color: AppColors.grey,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    /// Done Button
                    CustomButton(
                      label: "Done",
                      ontap: () {
                        Navigator.pop(context);
                      },
                    ),

                    SizedBox(height: 10),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
