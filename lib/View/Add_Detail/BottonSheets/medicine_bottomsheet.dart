import 'package:floraheart/Controllers/today_data_controller.dart';
import 'package:floraheart/Widgets/custom_button.dart';
import 'package:floraheart/config/Colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class MedicineBottomSheetExample extends StatefulWidget {
  const MedicineBottomSheetExample({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MedicineBottomSheetExampleState createState() =>
      _MedicineBottomSheetExampleState();
}

class _MedicineBottomSheetExampleState
    extends State<MedicineBottomSheetExample> {
  final TodayDataController controller = Get.find<TodayDataController>();
  final RxString selectedMedicine = "".obs;

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
    // Load existing selection from controller
    selectedMedicine.value = controller.medicine.value;

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
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Choose Medicine",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 16),
                ...medicines.map((medicine) {
                  return Obx(() {
                    bool isSelected =
                        selectedMedicine.value == medicine['label'];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 6,
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(25),
                        onTap: () {
                          selectedMedicine.value = medicine['label'];
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
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
                  });
                }),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomButton(
                    label: "Done",
                    ontap: () {
                      controller.medicine.value = selectedMedicine.value;
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
      // After bottom sheet is closed, go back to previous screen
    ).then((_) {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Medicine Selection")),
      body: Center(
        child: ElevatedButton(
          onPressed: _showMedicineBottomSheet,
          child: const Text("Choose Medicine"),
        ),
      ),
    );
  }
}
