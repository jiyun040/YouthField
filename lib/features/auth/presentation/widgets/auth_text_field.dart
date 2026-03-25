import 'package:flutter/material.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final Widget? suffix;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.obscureText = false,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      enableSuggestions: !obscureText,
      autocorrect: !obscureText,
      style: YouthFieldTextStyle.body4.copyWith(
        color: YouthFieldColor.black800,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: YouthFieldTextStyle.body4.copyWith(
          color: YouthFieldColor.black500,
        ),
        suffixIcon: suffix,
        filled: true,
        fillColor: YouthFieldColor.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.all(20),
      ),
    );
  }
}
