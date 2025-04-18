import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final bool isPassword;
  final bool readOnly;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final int maxLines;
  final int? maxLength;
  final FocusNode? focusNode;
  final Color? fillColor;
  final TextCapitalization textCapitalization;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? contentPadding; // ✅ New parameter added here

  const CustomTextFormField({
    Key? key,
    this.controller,
    this.label,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.isPassword = false,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.validator,
    this.onChanged,
    this.onTap,
    this.maxLines = 1,
    this.maxLength,
    this.focusNode,
    this.fillColor,
    this.textCapitalization = TextCapitalization.sentences,
    this.textStyle,
    this.contentPadding, // ✅ Add this to constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      readOnly: readOnly,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      onChanged: onChanged,
      onTap: onTap,
      maxLines: maxLines,
      maxLength: maxLength,
      focusNode: focusNode,
      textCapitalization: textCapitalization,
      style: textStyle ?? Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon:
            suffixIcon != null
                ? GestureDetector(onTap: onSuffixTap, child: Icon(suffixIcon))
                : null,
        filled: true,
        fillColor: fillColor ?? Theme.of(context).colorScheme.surface,
        contentPadding:
            contentPadding ??
            const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 16,
            ), // ✅ Use passed padding or fallback default
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
