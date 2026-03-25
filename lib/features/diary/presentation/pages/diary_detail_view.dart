import 'package:flutter/material.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';
import 'package:youthfield/features/diary/domain/entities/diary_entry.dart';
import 'package:youthfield/features/diary/presentation/widgets/diary_condition_slider.dart';
import 'package:youthfield/features/diary/presentation/widgets/diary_section_label.dart';
import 'package:youthfield/features/diary/presentation/widgets/diary_text_field.dart';

class DiaryDetailView extends StatelessWidget {
  final DiaryEntry entry;
  static const _gap = SizedBox(height: 10);
  static const _section = SizedBox(height: 40);

  const DiaryDetailView({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final sleepText = (entry.sleepStart != null && entry.sleepEnd != null)
        ? '${entry.sleepStart} ~ ${entry.sleepEnd}'
        : '-';

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const DiarySectionLabel(label: '컨디션'),
          _gap,
          DiaryConditionSlider(
            value: entry.condition.toDouble(),
            onChanged: null,
          ),
          _section,
          Row(
            children: [
              const DiarySectionLabel(label: '수면 시간'),
              const SizedBox(width: 20),
              Text(
                sleepText,
                style: YouthFieldTextStyle.textCount.copyWith(
                  color: YouthFieldColor.black800,
                ),
              ),
            ],
          ),
          _section,
          const DiarySectionLabel(label: '경기 / 연습 내용'),
          _gap,
          DiaryReadOnlyText(text: entry.content),
          _section,
          const DiarySectionLabel(label: '잘한 점'),
          _gap,
          DiaryReadOnlyText(text: entry.goodPoints),
          _section,
          const DiarySectionLabel(label: '개선할 점'),
          _gap,
          DiaryReadOnlyText(text: entry.improvements),
        ],
      ),
    );
  }
}
