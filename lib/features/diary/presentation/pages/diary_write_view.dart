import 'package:flutter/material.dart';
import 'package:youthfield/core/widgets/yf_time_picker.dart';
import 'package:youthfield/features/diary/domain/entities/diary_entry.dart';
import 'package:youthfield/features/diary/presentation/widgets/diary_condition_slider.dart';
import 'package:youthfield/features/diary/presentation/widgets/diary_section_label.dart';
import 'package:youthfield/features/diary/presentation/widgets/diary_sleep_time_picker.dart';
import 'package:youthfield/features/diary/presentation/widgets/diary_submit_button.dart';
import 'package:youthfield/features/diary/presentation/widgets/diary_text_field.dart';

class DiaryWriteView extends StatefulWidget {
  final ValueChanged<DiaryEntry> onSave;

  const DiaryWriteView({super.key, required this.onSave});

  @override
  State<DiaryWriteView> createState() => _DiaryWriteViewState();
}

class _DiaryWriteViewState extends State<DiaryWriteView> {
  double _condition = 50;
  String? _sleepStart;
  String? _sleepEnd;
  static const spacing10 = SizedBox(height: 10);
  static const spacing40 = SizedBox(height: 40);

  final _contentController = TextEditingController();
  final _goodController = TextEditingController();
  final _improvController = TextEditingController();

  @override
  void dispose() {
    _contentController.dispose();
    _goodController.dispose();
    _improvController.dispose();
    super.dispose();
  }

  bool get _canSave => _contentController.text.trim().isNotEmpty;

  Future<void> _pickTime(bool isStart) async {
    final time = await YFTimePicker.show(
      context: context,
      title: isStart ? '취침시간' : '기상시간',
      initialTime: isStart ? _sleepStart : _sleepEnd,
    );
    if (time != null && mounted) {
      setState(() {
        if (isStart) {
          _sleepStart = time;
        } else {
          _sleepEnd = time;
        }
      });
    }
  }

  void _handleSave() {
    final entry = DiaryEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      condition: _condition.round(),
      sleepStart: _sleepStart,
      sleepEnd: _sleepEnd,
      content: _contentController.text.trim(),
      goodPoints: _goodController.text.trim(),
      improvements: _improvController.text.trim(),
    );
    widget.onSave(entry);
  }

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
            value: _condition,
            onChanged: (v) => setState(() => _condition = v),
          ),
          spacing40,
          const DiarySectionLabel(label: '수면 시간'),
          spacing10,
          DiarySleepTimePicker(
            sleepStart: _sleepStart,
            sleepEnd: _sleepEnd,
            onPickStart: () => _pickTime(true),
            onPickEnd: () => _pickTime(false),
          ),
          spacing40,
          DiaryLabelRow(
            label: '경기 / 연습 내용',
            count: _contentController.text.length,
            maxCount: 1000,
          ),
         spacing10,
          DiaryTextField(
            controller: _contentController,
            maxLength: 1000,
            hintText: '경기 / 연습 내용을 기록해주세요.',
            minLines: 12,
            onChanged: (_) => setState(() {}),
          ),
          spacing40,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DiaryLabelRow(
                      label: '잘한 점',
                      count: _goodController.text.length,
                      maxCount: 1000,
                    ),
                    spacing10,
                    DiaryTextField(
                      controller: _goodController,
                      maxLength: 1000,
                      hintText: '잘한 점을 기록해주세요.',
                      minLines: 10,
                      onChanged: (_) => setState(() {}),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DiaryLabelRow(
                      label: '개선할 점',
                      count: _improvController.text.length,
                      maxCount: 1000,
                    ),
                    spacing10,
                    DiaryTextField(
                      controller: _improvController,
                      maxLength: 1000,
                      hintText: '개선할 점을 기록해주세요.',
                      minLines: 10,
                      onChanged: (_) => setState(() {}),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 100),
          DiarySubmitButton(
            enabled: _canSave,
            onPressed: _canSave ? _handleSave : null,
          ),
        ],
      ),
    );
  }
}
