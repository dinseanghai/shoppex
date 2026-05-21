import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'loading_widget.dart';

enum ButtonType { elevated, filled, tonal, outlined, text, icon }

class CustomButton extends StatelessWidget {
  // Made text optional (?) so we can omit it safely for iconButton
  final String? text;
  final VoidCallback? onPressed;
  final ButtonType buttontype;
  final IconData? icon;
  final IconAlignment iconAlignment;
  final bool isLoading;
  final double? width;
  final double height;
  final Widget? textWidget;
  final bool isBold;

  const CustomButton({
    super.key,
    this.text, // Text is now optional here but guarded by asserts below
    required this.onPressed,
    this.buttontype = ButtonType.filled,
    this.icon,
    this.iconAlignment = IconAlignment.start,
    this.isLoading = false,
    this.width,
    this.height = 48.0,
    this.textWidget,
    this.isBold = false,
  })  : assert(
  buttontype == ButtonType.icon ? icon != null : true,
  'An icon must be provided if buttontype is ButtonType.iconButton',
  ),
        assert(
        buttontype != ButtonType.icon ? text != null : true,
        'Text is required for all button types except iconButton',
        );

  // --- Button Styles Linked to App Tokens ---
  ButtonStyle _elevateStyle() {
    return ElevatedButton.styleFrom(
      elevation: 2,
      backgroundColor: AppColors.buttonPrimary,
      foregroundColor: AppColors.textOnPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    );
  }

  ButtonStyle _filledStyle() {
    return FilledButton.styleFrom(
      backgroundColor: AppColors.buttonPrimary,
      foregroundColor: AppColors.textOnPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    );
  }

  ButtonStyle _tonalStyle() {
    return FilledButton.styleFrom(
      backgroundColor: AppColors.info.withOpacity(0.2),
      foregroundColor: AppColors.buttonPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    );
  }

  ButtonStyle _outlinedStyle() {
    return OutlinedButton.styleFrom(
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.buttonPrimary,
      side: const BorderSide(color: AppColors.buttonPrimary, width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    );
  }

  ButtonStyle _textStyle() {
    return TextButton.styleFrom(
      foregroundColor: AppColors.buttonPrimary,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      minimumSize: Size.zero,
    ).copyWith(
      overlayColor: WidgetStateProperty.all(Colors.transparent),
    );
  }

  ButtonStyle _iconButtonStyle() {
    return IconButton.styleFrom(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.textPrimary,
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. Determine text styling colors dynamically based on background
    final bool isDarkBackground = buttontype == ButtonType.filled ||
        buttontype == ButtonType.elevated ||
        buttontype == ButtonType.icon;

    final TextStyle defaultStyle = AppTextStyles.buttonPrimary.copyWith(
      color: isDarkBackground ? AppColors.textOnPrimary : AppColors.buttonPrimary,
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
    );

    // 2. Select the content layer (Default Text vs Custom Widget / Obx)
    // Safe-checked text fallback to empty string if it's an icon button
    final Widget labelWidget = textWidget ?? Text(text ?? '', style: defaultStyle);

    // 3. Modern Loading Indicator integration with explicit style mapping
    final Widget finalContent = isLoading
        ? LoadingWidget(
      isButtonMode: true,
      color: isDarkBackground ? AppColors.textOnPrimary : AppColors.buttonPrimary,
    )
        : labelWidget;

    // 4. Select Button Styles Configuration
    ButtonStyle currentStyle;
    switch (buttontype) {
      case ButtonType.elevated: currentStyle = _elevateStyle(); break;
      case ButtonType.filled: currentStyle = _filledStyle(); break;
      case ButtonType.tonal: currentStyle = _tonalStyle(); break;
      case ButtonType.outlined: currentStyle = _outlinedStyle(); break;
      case ButtonType.text: currentStyle = _textStyle(); break;
      case ButtonType.icon: currentStyle = _iconButtonStyle(); break;
    }

    // 5. Build Content Engine Layout
    Widget button;
    if (buttontype == ButtonType.icon) {
      button = isLoading
          ? IconButton(onPressed: onPressed, style: currentStyle, icon: finalContent)
          : IconButton(onPressed: onPressed, style: currentStyle, icon: Icon(icon));
    } else if (icon != null && !isLoading) {
      button = _buildIconButton(currentStyle, finalContent);
    } else {
      button = _buildStandardButton(currentStyle, finalContent);
    }

    // 6. Layout Bounds Control
    // For pure icon buttons, we don't want double.infinity width by default,
    // so we fall back to matching the height (creating a perfect square/circle).
    final double defaultWidth = buttontype == ButtonType.icon ? height : double.infinity;

    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: width ?? defaultWidth,
        height: height,
        child: button,
      ),
    );
  }

  Widget _buildIconButton(ButtonStyle style, Widget label) {
    switch (buttontype) {
      case ButtonType.elevated:
        return ElevatedButton.icon(onPressed: onPressed, style: style, icon: Icon(icon), label: label, iconAlignment: iconAlignment);
      case ButtonType.filled:
        return FilledButton.icon(onPressed: onPressed, style: style, icon: Icon(icon), label: label, iconAlignment: iconAlignment);
      case ButtonType.tonal:
        return FilledButton.tonalIcon(onPressed: onPressed, style: style, icon: Icon(icon), label: label, iconAlignment: iconAlignment);
      case ButtonType.outlined:
        return OutlinedButton.icon(onPressed: onPressed, style: style, icon: Icon(icon), label: label, iconAlignment: iconAlignment);
      case ButtonType.text:
        return TextButton.icon(onPressed: onPressed, style: style, icon: Icon(icon), label: label, iconAlignment: iconAlignment);
      case ButtonType.icon:
        return const SizedBox.shrink(); // Handled directly in build layout
    }
  }

  Widget _buildStandardButton(ButtonStyle style, Widget child) {
    switch (buttontype) {
      case ButtonType.elevated: return ElevatedButton(onPressed: onPressed, style: style, child: child);
      case ButtonType.filled: return FilledButton(onPressed: onPressed, style: style, child: child);
      case ButtonType.tonal: return FilledButton.tonal(onPressed: onPressed, style: style, child: child);
      case ButtonType.outlined: return OutlinedButton(onPressed: onPressed, style: style, child: child);
      case ButtonType.text: return TextButton(onPressed: onPressed, style: style, child: child);
      case ButtonType.icon: return const SizedBox.shrink(); // Handled directly in build layout
    }
  }
}