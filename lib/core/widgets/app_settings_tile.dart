import 'package:flutter/material.dart';

import '../theme/color/app_colors.dart';
import '../theme/icons/app_icon.dart';
import '../theme/icons/app_icon_data.dart';
import '../theme/icons/app_icons.dart';
import '../theme/text/app_text_theme.dart';

class AppSettingsTile extends StatelessWidget {
  const AppSettingsTile({
    super.key,
    required this.title,
    this.width,
    this.height = 60,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
    this.margin,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1,
    this.borderRadius = 16,
    this.textStyle,
    this.textColor,
    this.leadingIcon,
    this.trailingIcon = AppIcons.caretRight,
    this.leadingIconColor,
    this.trailingIconColor,
    this.leadingIconSize = 22,
    this.trailingIconSize = 22,
    this.leadingTextGap = 14,
    this.textTrailingGap = 12,
    this.onTap,
    this.enabled = true,
    this.splashColor,
    this.highlightColor,
  });

  final String title;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final double borderRadius;
  final TextStyle? textStyle;
  final Color? textColor;
  final AppIconData? leadingIcon;
  final AppIconData? trailingIcon;
  final Color? leadingIconColor;
  final Color? trailingIconColor;
  final double leadingIconSize;
  final double trailingIconSize;
  final double leadingTextGap;
  final double textTrailingGap;
  final VoidCallback? onTap;
  final bool enabled;
  final Color? splashColor;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveEnabled = enabled && onTap != null;
    final resolvedBackground = backgroundColor ?? colorScheme.surface;
    final resolvedBorder = borderColor ?? colorScheme.outline;
    final resolvedTextColor = textColor ?? colorScheme.onSurface;
    final resolvedLeadingIconColor = leadingIconColor ?? colorScheme.onSurface;
    final resolvedTrailingIconColor =
        trailingIconColor ?? colorScheme.onSurface;
    final resolvedTextStyle =
        textStyle ??
        Theme.of(context).textTheme.ui(
          size: AppTextSize.regular,
          spacing: AppTextSpacing.none,
          weight: AppTextWeight.medium,
        );
    final contentOpacity = enabled ? 1.0 : 0.48;

    return Container(
      width: width,
      height: height,
      margin: margin,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: effectiveEnabled ? onTap : null,
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: splashColor,
          highlightColor: highlightColor,
          child: Ink(
            padding: padding,
            decoration: BoxDecoration(
              color: resolvedBackground,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: resolvedBorder, width: borderWidth),
            ),
            child: Opacity(
              opacity: contentOpacity,
              child: Row(
                children: [
                  if (leadingIcon != null) ...[
                    AppIcon(
                      leadingIcon!,
                      size: leadingIconSize,
                      color: resolvedLeadingIconColor,
                    ),
                    SizedBox(width: leadingTextGap),
                  ],
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: resolvedTextStyle.copyWith(
                        color: resolvedTextColor,
                      ),
                    ),
                  ),
                  if (trailingIcon != null) ...[
                    SizedBox(width: textTrailingGap),
                    AppIcon(
                      trailingIcon!,
                      size: trailingIconSize,
                      color: resolvedTrailingIconColor,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
