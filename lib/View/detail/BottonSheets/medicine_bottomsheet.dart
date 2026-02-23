// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'package:floraheart/View/Widgets/custom_button.dart';
import 'package:floraheart/config/Colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MedicineBottomSheetExample extends StatefulWidget {
  const MedicineBottomSheetExample({super.key});

  @override
  _MedicineBottomSheetExampleState createState() =>
      _MedicineBottomSheetExampleState();
}

class _MedicineBottomSheetExampleState
    extends State<MedicineBottomSheetExample> {
  String selectedMedicine = "Contraceptive Pill";

  final List<Map<String, dynamic>> medicines = [
    {"label": "Contraceptive Pill", "icon": "assets/contraceptive.svg"},
    {"label": "V-Ring", "icon": "assets/vring.svg"},
    {"label": "Patch", "icon": "assets/patch.svg"},
    {"label": "Injection", "icon": "assets/injection.svg"},
    {"label": "IUD", "icon": "assets/iud.svg"},
    {"label": "Implant", "icon": "assets/implant.svg"},
  ];

  @override
  void initState() {
    super.initState();
    // Automatically open the bottom sheet when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showMedicineBottomSheet();
    });
  }

  void _showMedicineBottomSheet() async {
    // Wait for the bottom sheet to close
    await showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Choose Medicine",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 16),
                    ...medicines.map((medicine) {
                      bool isSelected = selectedMedicine == medicine['label'];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 6,
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(25),
                          onTap: () {
                            setModalState(() {
                              selectedMedicine = medicine['label'];
                            });
                            // Optional: close the sheet immediately on tap
                            // Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.grey.shade300,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  medicine['label'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                                SvgPicture.asset(
                                  medicine['icon'],
                                  width: 24,
                                  height: 24,
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.black54,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    SizedBox(height: 16),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: CustomButton(
                        label: "Done",
                        ontap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    // After bottom sheet is closed, go back to previous screen
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Medicine Bottom Sheet")),
      body: Center(
        child: ElevatedButton(
          onPressed: _showMedicineBottomSheet,
          child: Text("Choose Medicine"),
        ),
      ),
    );
  }
}
