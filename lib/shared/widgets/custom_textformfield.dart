import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shoppex/core/constants/app_colors.dart';

class CustomFormField extends StatefulWidget {
  final String? label;
  final String? hint;
  final Widget? prefix;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool isPassword;
  final bool? autofocus;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final bool showCheckmarkOnInput;
  final List<TextInputFormatter>? inputFormatters;

  const CustomFormField({
    super.key,
    this.label,
    this.hint,
    this.prefix,
    this.prefixIcon,
    this.suffixIcon,
    this.isPassword = false,
    this.autofocus,
    this.controller,
    required this.keyboardType,
    this.validator,
    this.focusNode,
    this.showCheckmarkOnInput = false,
    this.inputFormatters,
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

    if (widget.controller != null) {
      _hasText = widget.controller!.text.isNotEmpty;
    }
  }

  @override
  void dispose() {
    _effectiveFocusNode.removeListener(_onFocusChange);
    if (widget.focusNode == null) {
      _effectiveFocusNode.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {});
  }

  Widget? _buildSuffixIcon() {
    if (widget.isPassword) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
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

    if (widget.showCheckmarkOnInput && _hasText) {
      return const Icon(
        Icons.check_circle_outline,
        color: AppColors.success,
        size: 22,
      );
    }

    return widget.suffixIcon;
  }

  @override
  Widget build(BuildContext context) {
    final Color currentIconColor = _effectiveFocusNode.hasFocus
        ? AppColors.buttonPrimary
        : Colors.grey.shade500;

    return TextFormField(
      focusNode: _effectiveFocusNode,
      autofocus: widget.autofocus ?? false,
      controller: widget.controller,
      obscureText: _obscureText,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      inputFormatters: widget.inputFormatters, // Correctly placed inside TextFormField configuration
      textAlignVertical: TextAlignVertical.center,
      onChanged: (value) {
        if (widget.showCheckmarkOnInput) {
          final containsText = value.isNotEmpty;
          if (_hasText != containsText) {
            setState(() {
              _hasText = containsText;
            });
          }
        }
      },
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
        ),
        floatingLabelStyle: WidgetStateTextStyle.resolveWith((states) {
          if (states.contains(WidgetState.focused)) {
            return const TextStyle(
              color: AppColors.buttonPrimary,
              fontWeight: FontWeight.bold,
            );
          }
          if (states.contains(WidgetState.error)) {
            return const TextStyle(
              color: AppColors.error,
              fontWeight: FontWeight.bold,
            );
          }
          return TextStyle(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.bold,
          );
        }),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: widget.hint,
        hintStyle: TextStyle(
          color: Colors.grey.shade400,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),

        prefix: widget.prefix,
        prefixIcon: widget.prefixIcon != null
            ? Icon(widget.prefixIcon, color: currentIconColor, size: 20)
            : null,
        suffixIcon: _buildSuffixIcon(),

        filled: true,
        fillColor: AppColors.background,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

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