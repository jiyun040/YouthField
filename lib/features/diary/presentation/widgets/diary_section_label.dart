import 'package:flutter/material.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';

class DiarySectionLabel extends StatelessWidget {
  final String label;

  const DiarySectionLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: YouthFieldTextStyle.body4,
    );
  }
}

class DiaryLabelRow extends StatelessWidget {
  final String label;
  final int count;
  final int maxCount;

  const DiaryLabelRow({
    super.key,
    required this.label,
    required this.count,
    required this.maxCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DiarySectionLabel(label: label),
        Text(
          '$count/$maxCount',
          style: YouthFieldTextStyle.placeholder.copyWith(
            color: YouthFieldColor.black500,
          ),
        ),
      ],
    );
  }
}
