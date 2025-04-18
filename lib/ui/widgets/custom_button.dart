import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final double? height;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final MainAxisAlignment alignment;
  final bool isOutlined;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height,
    this.borderRadius = 12.0,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.textStyle,
    this.padding,
    this.margin,
    this.alignment = MainAxisAlignment.center,
    this.isOutlined = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color finalBackgroundColor =
        backgroundColor ??
        (isOutlined ? Colors.transparent : Theme.of(context).primaryColor);

    final Color finalTextColor =
        textColor ??
        (isOutlined ? Theme.of(context).primaryColor : Colors.white);

    final Color finalBorderColor =
        borderColor ?? Theme.of(context).primaryColor;

    return Container(
      width: width,
      height: height,
      margin: margin,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          elevation: isOutlined ? 0 : 2,
          backgroundColor: finalBackgroundColor,
          foregroundColor: finalTextColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side:
                isOutlined
                    ? BorderSide(color: finalBorderColor, width: 1.5)
                    : BorderSide.none,
          ),
          padding:
              padding ??
              const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
        child:
            isLoading
                ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                : Row(
                  mainAxisAlignment: alignment,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 20, color: finalTextColor),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      text,
                      style:
                          textStyle ??
                          TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: finalTextColor,
                          ),
                    ),
                  ],
                ),
      ),
    );
  }
}
