import 'package:floraheart/config/Colors/colors.dart';
import 'package:flutter/material.dart';

class CustomArticleCard extends StatelessWidget {
  final String title;
  final String tag;
  final String imagePath;
  final VoidCallback? onTap;
  final bool isNetworkImage;

  const CustomArticleCard({
    super.key,
    required this.title,
    required this.tag,
    required this.imagePath,
    this.onTap,
    this.isNetworkImage = false,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),),
        child: Row(
          children: [
            /// Image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: isNetworkImage
                  ? Image.network(
                      imagePath,
                      width: width * 0.28,
                      height: width * 0.22,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      imagePath,
                      width: width * 0.28,
                      height: width * 0.22,
                      fit: BoxFit.cover,
                    ),
            ),

            const SizedBox(width: 12),

            /// Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Tag
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.lightgrey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  /// Title
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
