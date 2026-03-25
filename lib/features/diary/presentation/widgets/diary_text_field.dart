import 'package:flutter/material.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';

class DiaryTextField extends StatelessWidget {
  final TextEditingController controller;
  final int maxLength;
  final String hintText;
  final int minLines;
  final ValueChanged<String>? onChanged;

  const DiaryTextField({
    super.key,
    required this.controller,
    required this.maxLength,
    required this.hintText,
    this.minLines = 4,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: YouthFieldColor.blue50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        maxLines: null,
        minLines: minLines,
        maxLength: maxLength,
        onChanged: onChanged,
        buildCounter:
            (_, {required currentLength, required isFocused, maxLength}) =>
                null,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: YouthFieldTextStyle.placeholder.copyWith(
            color: YouthFieldColor.black300,
          ),
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.all(16),
        ),
        style: YouthFieldTextStyle.textCount,
      ),
    );
  }
}

class DiaryReadOnlyText extends StatelessWidget {
  final String text;

  const DiaryReadOnlyText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.isEmpty ? '-' : text,
      style: YouthFieldTextStyle.textCount.copyWith(
        color: text.isEmpty
            ? YouthFieldColor.black300
            : YouthFieldColor.black800,
      ),
    );
  }
}
