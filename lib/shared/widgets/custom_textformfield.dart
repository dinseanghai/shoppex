import 'package:flutter/material.dart';
import 'package:shoppex/core/constants/app_colors.dart';

class CustomFormField extends StatefulWidget {
  final String? label;
  final String? hint;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool isPassword;
  final bool? autofocus;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final bool showCheckmarkOnInput; // Added flag to toggle this feature selectively

  const CustomFormField({
    super.key,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.isPassword = false,
    this.autofocus,
    this.controller,
    required this.keyboardType,
    this.validator,
    this.focusNode,
    this.showCheckmarkOnInput = false, // Default is false so it doesn't affect all fields
  });

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  late bool _obscureText;
  late FocusNode _effectiveFocusNode;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;

    _effectiveFocusNode = widget.focusNode ?? FocusNode();
    _effectiveFocusNode.addListener(_onFocusChange);

    // Set up text controller listener for the checkmark behavior
    if (widget.showCheckmarkOnInput && widget.controller != null) {
      _hasText = widget.controller!.text.isNotEmpty;
      widget.controller!.addListener(_onTextChange);
    }
  }

  @override
  void dispose() {
    _effectiveFocusNode.removeListener(_onFocusChange);
    if (widget.focusNode == null) {
      _effectiveFocusNode.dispose();
    }

    // Clean up text listener safely
    if (widget.showCheckmarkOnInput && widget.controller != null) {
      widget.controller!.removeListener(_onTextChange);
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {});
  }

  void _onTextChange() {
    if (widget.controller == null) return;

    final containsText = widget.controller!.text.isNotEmpty;
    if (_hasText != containsText) {
      setState(() {
        _hasText = containsText;
      });
    }
  }

  Widget? _buildSuffixIcon() {
    // 1. Password Visibility Toggle takes priority
    if (widget.isPassword) {
      return IconButton(
        icon: Icon(
          _obscureText
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          size: 20,
          color: Colors.grey,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }

    // 2. Dynamic Green Checkmark if enabled and text is present
    if (widget.showCheckmarkOnInput && _hasText) {
      return const Icon(
        Icons.check_circle_outline, // Renders a filled green checkmark circle
        color: AppColors.success,
        size: 22,
      );
    }

    // 3. Fallback to manually provided suffixIcon (or null/blank)
    return widget.suffixIcon;
  }

  @override
  Widget build(BuildContext context) {
    final Color prefixIconColor = _effectiveFocusNode.hasFocus
        ? AppColors.buttonPrimary
        : Colors.grey;

    return TextFormField(
      focusNode: _effectiveFocusNode,
      autofocus: widget.autofocus ?? false,
      controller: widget.controller,
      obscureText: _obscureText,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: WidgetStateTextStyle.resolveWith((states) {
          if (states.contains(WidgetState.focused)) {
            return const TextStyle(
              color: AppColors.buttonPrimary,
              fontWeight: FontWeight.bold,
            );
          }
          return const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold);
        }),
        floatingLabelStyle: WidgetStateTextStyle.resolveWith((states) {
          if (states.contains(WidgetState.focused)) {
            return const TextStyle(
              color: AppColors.buttonPrimary,
              fontWeight: FontWeight.bold,
            );
          }
          return const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold);
        }),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: widget.hint,
        hintStyle: TextStyle(
          color: Colors.grey.shade400,
          fontSize: 13,
          fontWeight: FontWeight.normal,
        ),
        prefixIcon: widget.prefixIcon != null
            ? Icon(widget.prefixIcon, color: prefixIconColor, size: 20)
            : null,

        // Use our helper to decide which suffix icon layout to build
        suffixIcon: _buildSuffixIcon(),

        filled: true,
        fillColor: AppColors.background,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.buttonPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        errorStyle: const TextStyle(color: AppColors.error),
      ),
    );
  }
}