import 'package:floraheart/config/Colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomProfileListtile extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  const CustomProfileListtile({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true, // reduces vertical space
      contentPadding: EdgeInsets.zero,
      minVerticalPadding:
          0, // ensures minimal padding on newer Flutter versions
      leading: CircleAvatar(
        backgroundColor: AppColors.lightgrey,
        child: SvgPicture.asset(image, width: 25, height: 25),
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppColors.grey,
        ),
      ),
    );
  }
}

// two----------------------------------------------
class CustomProfileListtow extends StatelessWidget {
  final String image;
  final String title;
  final VoidCallback? onTap;
  const CustomProfileListtow({
    super.key,
    required this.image,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true, // reduces vertical space
      contentPadding: EdgeInsets.symmetric(vertical: 5),
      minVerticalPadding:
          0, // ensures minimal padding on newer Flutter versions
      leading: CircleAvatar(
        backgroundColor: AppColors.lightgrey,
        child: SvgPicture.asset(image, width: 25, height: 25),
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
      trailing: IconButton(
        onPressed: onTap,
        icon: Icon(Icons.arrow_forward_ios, size: 15, color: AppColors.primary),
      ),
    );
  }
}
