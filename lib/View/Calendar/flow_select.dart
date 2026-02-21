import 'package:floraheart/config/Colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FlowSelector extends StatefulWidget {
  const FlowSelector({super.key});

  @override
  State<FlowSelector> createState() => _FlowSelectorState();
}

class _FlowSelectorState extends State<FlowSelector> {
  int selectedIndex = -1; // nothing selected initially

  Widget buildItem({
    required int index,
    required String title,
    required String asset,
  }) {
    final bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : Colors.grey.shade300,
              ),
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              asset,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: isSelected
                  ? AppColors.primary
                  : AppColors.grey,
              fontSize: 11,
              fontWeight:
                  isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildItem(
          index: 0,
          title: "Light",
          asset: "assets/lightdrop.svg",
        ),
        buildItem(
          index: 1,
          title: "Medium",
          asset: "assets/mediumdrop.svg",
        ),
        buildItem(
          index: 2,
          title: "Heavy",
          asset: "assets/heavydrops.svg",
        ),
        buildItem(
          index: 3,
          title: "Disaster",
          asset: "assets/disasterdrops.svg",
        ),
      ],
    );
  }
}