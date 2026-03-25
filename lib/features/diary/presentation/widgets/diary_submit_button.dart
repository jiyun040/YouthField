import 'package:flutter/material.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';

class DiarySubmitButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback? onPressed;

  const DiarySubmitButton({super.key, required this.enabled, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: enabled ? YouthFieldColor.blue700 : YouthFieldColor.black50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          '작성하기',
          textAlign: TextAlign.center,
          style: YouthFieldTextStyle.body4.copyWith(
            color: enabled ? YouthFieldColor.white : YouthFieldColor.black300,
          ),
        ),
      ),
    );
  }
}
