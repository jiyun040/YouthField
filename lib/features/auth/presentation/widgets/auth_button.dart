import 'package:flutter/material.dart';
import 'package:youthfield/core/constants/text_style.dart';

class AuthButton extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color labelColor;
  final VoidCallback onTap;
  final double? width;
  final double height;
  final Widget? prefix;

  const AuthButton({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.labelColor,
    required this.onTap,
    this.width,
    this.height = 52,
    this.prefix,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (prefix != null) ...[prefix!, const SizedBox(width: 12)],
            Text(
              label,
              style: YouthFieldTextStyle.body4.copyWith(color: labelColor),
            ),
          ],
        ),
      ),
    );
  }
}
