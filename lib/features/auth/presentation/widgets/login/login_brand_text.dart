import 'package:flutter/material.dart';

import '../../../../../core/theme/color/app_colors.dart';
import '../../../../../core/theme/text/app_fonts.dart';
import '../../../../../core/widgets/text/text.dart';

class LoginBrandText extends StatelessWidget {
  const LoginBrandText({super.key});

  @override
  Widget build(BuildContext context) {
    return AppText(
      'Beacon',
      textAlign: TextAlign.center,
      color: AppColors.sky100,
      style: AppFonts.resolveTextStyle(
        const TextStyle(
          fontSize: 64,
          fontWeight: FontWeight.w400,
          height: 0.25,
        ),
        fontFamily: AppFonts.kavoon,
      ),
    );
  }
}
