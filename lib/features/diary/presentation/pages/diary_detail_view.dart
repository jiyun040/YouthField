import 'package:flutter/material.dart';
import 'package:youthfield/features/diary/domain/entities/diary_entry.dart';
import 'package:youthfield/features/diary/presentation/widgets/diary_condition_slider.dart';
import 'package:youthfield/features/diary/presentation/widgets/diary_section_label.dart';
import 'package:youthfield/features/diary/presentation/widgets/diary_sleep_time_picker.dart';
import 'package:youthfield/features/diary/presentation/widgets/diary_text_field.dart';

class DiaryDetailView extends StatelessWidget {
  final DiaryEntry entry;
  static const spacing10 = SizedBox(height: 10);
  static const spacing20 = SizedBox(height: 20);

  const DiaryDetailView({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const DiarySectionLabel(label: '컨디션'),
          spacing10,
          DiaryConditionSlider(
            value: entry.condition.toDouble(),
            onChanged: null,
          ),
          spacing20,
          const DiarySectionLabel(label: '수면 시간'),
          spacing10,
          DiaryReadOnlySleepTime(
            sleepStart: entry.sleepStart,
            sleepEnd: entry.sleepEnd,
          ),
          spacing20,
          const DiarySectionLabel(label: '경기 / 연습 내용'),
          spacing10,
          DiaryReadOnlyText(text: entry.content),
          spacing20,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const DiarySectionLabel(label: '잘한 점'),
                    spacing10,
                    DiaryReadOnlyText(text: entry.goodPoints),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const DiarySectionLabel(label: '개선할 점'),
                    spacing10,
                    DiaryReadOnlyText(text: entry.improvements),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
