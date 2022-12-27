import 'package:flutter/material.dart';

import '../utils/screen_util/screen_util.dart';
import '../utils/theme/app_colors.dart';
import '../utils/theme/app_text_style.dart';

class LanguageSelectionWidget extends StatelessWidget {
  const LanguageSelectionWidget({
    super.key,
    required this.title,
    required this.subTitle,
    required this.imageUrl,
    required this.selectedIndex,
    required this.index,
    required this.onItemTap,
  });

  final String title;
  final String subTitle;
  final String imageUrl;
  final int? selectedIndex;
  final int index;
  final VoidCallback onItemTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppEdgeInsets.instance.only(right: 8, left: 8, bottom: 16),
      padding: AppEdgeInsets.instance.only(right: 16, left: 16, top: 4),
      decoration: BoxDecoration(
        color: (selectedIndex != null && selectedIndex == index)
            ? sassyGreen
            : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: (selectedIndex != null && selectedIndex == index)
              ? japaneseLaurel
              : americanSilver,
          width: (selectedIndex != null && selectedIndex == index)
              ? 1.5.toWidth
              : 1.toWidth,
        ),
      ),
      child: InkWell(
        onTap: onItemTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      title,
                      style: AppTextStyle().light16BalticSea.copyWith(
                            fontSize: 20.toFont,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                  SizedBox(height: 4.toHeight),
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      subTitle,
                      style: AppTextStyle()
                          .light16BalticSea
                          .copyWith(color: dolphinGray),
                    ),
                  ),
                ],
              ),
            ),
            Image.asset(
              imageUrl,
              height: 76.toHeight,
            ),
          ],
        ),
      ),
    );
  }
}
