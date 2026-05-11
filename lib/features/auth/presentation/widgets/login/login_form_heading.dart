import 'package:flutter/material.dart';

import '../../../../../core/theme/color/app_colors.dart';
import '../../../../../core/theme/text/app_fonts.dart';

class LoginFormHeading extends StatelessWidget {
  const LoginFormHeading({super.key});

  @override
  Widget build(BuildContext context) {
    final headingStyle = AppFonts.resolveTextStyle(
      const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        height: 0.82,
      ),
      fontFamily: AppFonts.defaultFamily,
    );

    return Align(
      child: SizedBox(
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Đăng nhập',
                style: headingStyle.copyWith(color: AppColors.teal500),
              ),
              TextSpan(
                text: ' vào tài khoản',
                style: headingStyle.copyWith(color: AppColors.ink600),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
