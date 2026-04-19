import 'package:flutter/material.dart';

import '../../theme/color/app_colors.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key, this.onPressed, this.size = 28});

  final VoidCallback? onPressed;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(52),
        onTap: onPressed ?? () => Navigator.of(context).maybePop(),
        child: Container(
          padding: const EdgeInsets.all(8),
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: AppColors.sky400,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(52),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: size,
                height: size,
                child: const Center(
                  child: Icon(Icons.chevron_left, color: AppColors.ink500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
