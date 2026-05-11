import 'package:flutter/material.dart';

import '../theme/color/app_colors.dart';
import '../theme/text/app_text_theme.dart';

class AppSettingsSection extends StatelessWidget {
  const AppSettingsSection({
    super.key,
    required this.title,
    required this.children,
    this.titleToChildrenGap = 12,
    this.tileSpacing = 12,
    this.margin,
    this.padding = EdgeInsets.zero,
    this.titleStyle,
    this.titleColor,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
  });

  final String title;
  final List<Widget> children;
  final double titleToChildrenGap;
  final double tileSpacing;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry padding;
  final TextStyle? titleStyle;
  final Color? titleColor;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final resolvedTitleStyle =
        titleStyle ??
        Theme.of(context).textTheme.ui(
          size: AppTextSize.regular,
          spacing: AppTextSpacing.none,
          weight: AppTextWeight.bold,
        );

    return Container(
      margin: margin,
      padding: padding,
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Text(
            title,
            style: resolvedTitleStyle.copyWith(
              color: titleColor ?? AppColors.ink500,
            ),
          ),
          SizedBox(height: titleToChildrenGap),
          for (var index = 0; index < children.length; index++) ...[
            if (index > 0) SizedBox(height: tileSpacing),
            children[index],
          ],
        ],
      ),
    );
  }
}
