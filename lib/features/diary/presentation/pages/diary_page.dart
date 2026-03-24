import 'package:flutter/material.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';
import 'package:youthfield/features/diary/domain/entities/diary_entry.dart';

enum DiaryMode { list, write, detail }

const int _kPageSize = 10;
const double _kRowHeight = 80;
const double _kRowGap = 10;

class DiaryBody extends StatelessWidget {
  final DiaryMode mode;
  final DiaryEntry? selectedEntry;
  final ValueChanged<DiaryEntry> onEntryTap;
  final ValueChanged<DiaryEntry> onSave;
  final List<DiaryEntry> entries;

  const DiaryBody({
    super.key,
    required this.mode,
    required this.entries,
    required this.onEntryTap,
    required this.onSave,
    this.selectedEntry,
  });

  @override
  Widget build(BuildContext context) {
    switch (mode) {
      case DiaryMode.list:
        return _DiaryListView(entries: entries, onEntryTap: onEntryTap);
      case DiaryMode.write:
        return _DiaryWriteView(onSave: onSave);
      case DiaryMode.detail:
        if (selectedEntry == null) {
          return _DiaryListView(entries: entries, onEntryTap: onEntryTap);
        }
        return _DiaryDetailView(entry: selectedEntry!);
    }
  }
}

class _DiaryListView extends StatefulWidget {
  final List<DiaryEntry> entries;
  final ValueChanged<DiaryEntry> onEntryTap;

  const _DiaryListView({required this.entries, required this.onEntryTap});

  @override
  State<_DiaryListView> createState() => _DiaryListViewState();
}

class _DiaryListViewState extends State<_DiaryListView> {
  final _pageController = PageController();
  int _currentPage = 0;

  List<DiaryEntry> get _sorted =>
      [...widget.entries]..sort((a, b) => b.date.compareTo(a.date));

  int get _totalPages {
    final n = _sorted.length;
    if (n == 0) return 1;
    return (n / _kPageSize).ceil();
  }

  int get _indicatorIndex {
    if (_totalPages <= 1 || _currentPage == 0) return 0;
    if (_currentPage == _totalPages - 1) return 2;
    return 1;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sorted = _sorted;

    if (sorted.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 80),
          child: Text(
            '작성된 일지가 없습니다.',
            style: YouthFieldTextStyle.textCount.copyWith(
              color: YouthFieldColor.black500,
            ),
          ),
        ),
      );
    }
    const pageViewHeight = _kPageSize * (_kRowHeight + _kRowGap);

    return Column(
      children: [
        const SizedBox(height: 24),
        SizedBox(
          height: pageViewHeight,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _totalPages,
            onPageChanged: (page) => setState(() => _currentPage = page),
            itemBuilder: (context, pageIndex) {
              final start = pageIndex * _kPageSize;
              final end = (start + _kPageSize).clamp(0, sorted.length);
              final pageEntries = sorted.sublist(start, end);

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: pageEntries
                      .map(
                        (entry) => _DiaryListRow(
                          entry: entry,
                          onTap: () => widget.onEntryTap(entry),
                        ),
                      )
                      .toList(),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        _DiaryPageIndicator(activeIndex: _indicatorIndex),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _DiaryPageIndicator extends StatelessWidget {
  final int activeIndex;

  const _DiaryPageIndicator({required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: i == activeIndex
                ? YouthFieldColor.blue700
                : YouthFieldColor.black50,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}

class _DiaryListRow extends StatelessWidget {
  final DiaryEntry entry;
  final VoidCallback onTap;

  const _DiaryListRow({required this.entry, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: _kRowHeight,
        margin: const EdgeInsets.only(bottom: _kRowGap),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: YouthFieldColor.blue50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 160,
              child: Text(
                entry.formattedDate,
                style: YouthFieldTextStyle.textCount.copyWith(
                  color: YouthFieldColor.black800,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                entry.content,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: YouthFieldTextStyle.textCount.copyWith(
                  color: YouthFieldColor.black500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DiaryWriteView extends StatefulWidget {
  final ValueChanged<DiaryEntry> onSave;

  const _DiaryWriteView({required this.onSave});

  @override
  State<_DiaryWriteView> createState() => _DiaryWriteViewState();
}

class _DiaryWriteViewState extends State<_DiaryWriteView> {
  double _condition = 50;
  String? _sleepStart;
  String? _sleepEnd;

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
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: YouthFieldColor.blue700,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && mounted) {
      final formatted =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      setState(() {
        if (isStart) {
          _sleepStart = formatted;
        } else {
          _sleepEnd = formatted;
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
          _SectionLabel(label: '컨디션'),
          const SizedBox(height: 8),
          _ConditionSlider(
            value: _condition,
            onChanged: (v) => setState(() => _condition = v),
          ),
          const SizedBox(height: 20),
          _SectionLabel(label: '수면 시간'),
          const SizedBox(height: 8),
          _SleepTimePicker(
            sleepStart: _sleepStart,
            sleepEnd: _sleepEnd,
            onPickStart: () => _pickTime(true),
            onPickEnd: () => _pickTime(false),
          ),
          const SizedBox(height: 20),
          _LabelRow(
            label: '경기 / 연습 내용',
            count: _contentController.text.length,
            maxCount: 1000,
          ),
          const SizedBox(height: 8),
          _DiaryTextField(
            controller: _contentController,
            maxLength: 1000,
            hintText: '경기 / 연습 내용을 기록해주세요.',
            minLines: 7,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _LabelRow(
                      label: '잘한 점',
                      count: _goodController.text.length,
                      maxCount: 1000,
                    ),
                    const SizedBox(height: 8),
                    _DiaryTextField(
                      controller: _goodController,
                      maxLength: 1000,
                      hintText: '잘한 점을 기록해주세요.',
                      minLines: 5,
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
                    _LabelRow(
                      label: '개선할 점',
                      count: _improvController.text.length,
                      maxCount: 1000,
                    ),
                    const SizedBox(height: 8),
                    _DiaryTextField(
                      controller: _improvController,
                      maxLength: 1000,
                      hintText: '개선할 점을 기록해주세요.',
                      minLines: 5,
                      onChanged: (_) => setState(() {}),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          _SubmitButton(
            enabled: _canSave,
            onPressed: _canSave ? _handleSave : null,
          ),
        ],
      ),
    );
  }
}

class _DiaryDetailView extends StatelessWidget {
  final DiaryEntry entry;

  const _DiaryDetailView({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SectionLabel(label: '컨디션'),
          const SizedBox(height: 8),
          _ConditionSlider(
            value: entry.condition.toDouble(),
            onChanged: null,
          ),
          const SizedBox(height: 20),
          _SectionLabel(label: '수면 시간'),
          const SizedBox(height: 8),
          _ReadOnlySleepTime(
            sleepStart: entry.sleepStart,
            sleepEnd: entry.sleepEnd,
          ),
          const SizedBox(height: 20),
          _SectionLabel(label: '경기 / 연습 내용'),
          const SizedBox(height: 8),
          _ReadOnlyText(text: entry.content),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _SectionLabel(label: '잘한 점'),
                    const SizedBox(height: 8),
                    _ReadOnlyText(text: entry.goodPoints),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _SectionLabel(label: '개선할 점'),
                    const SizedBox(height: 8),
                    _ReadOnlyText(text: entry.improvements),
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

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: YouthFieldTextStyle.textCount.copyWith(
        color: YouthFieldColor.black800,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _LabelRow extends StatelessWidget {
  final String label;
  final int count;
  final int maxCount;

  const _LabelRow({
    required this.label,
    required this.count,
    required this.maxCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _SectionLabel(label: label),
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

class _ConditionSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double>? onChanged;

  const _ConditionSlider({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('0%'),
            Text('25%'),
            Text('50%'),
            Text('75%'),
            Text('100%'),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: YouthFieldColor.blue700,
            inactiveTrackColor: YouthFieldColor.black50,
            thumbColor: YouthFieldColor.blue700,
            overlayColor: YouthFieldColor.blue300.withValues(alpha: 0.2),
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            disabledActiveTrackColor: YouthFieldColor.blue300,
            disabledInactiveTrackColor: YouthFieldColor.black50,
            disabledThumbColor: YouthFieldColor.blue300,
          ),
          child: Slider(
            value: value,
            min: 0,
            max: 100,
            divisions: 4,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class _SleepTimePicker extends StatelessWidget {
  final String? sleepStart;
  final String? sleepEnd;
  final VoidCallback onPickStart;
  final VoidCallback onPickEnd;

  const _SleepTimePicker({
    required this.sleepStart,
    required this.sleepEnd,
    required this.onPickStart,
    required this.onPickEnd,
  });

  Widget _timeBox(String? time, String placeholder, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minWidth: 80),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: YouthFieldColor.blue50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          time ?? placeholder,
          style: YouthFieldTextStyle.textCount.copyWith(
            color: time != null
                ? YouthFieldColor.black800
                : YouthFieldColor.black300,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _timeBox(sleepStart, '취침시간', onPickStart),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            '~',
            style: YouthFieldTextStyle.textCount.copyWith(
              color: YouthFieldColor.black500,
            ),
          ),
        ),
        _timeBox(sleepEnd, '기상시간', onPickEnd),
      ],
    );
  }
}

class _ReadOnlySleepTime extends StatelessWidget {
  final String? sleepStart;
  final String? sleepEnd;

  const _ReadOnlySleepTime({this.sleepStart, this.sleepEnd});

  @override
  Widget build(BuildContext context) {
    final text = (sleepStart != null && sleepEnd != null)
        ? '$sleepStart ~ $sleepEnd'
        : '-';
    return Text(
      text,
      style: YouthFieldTextStyle.textCount.copyWith(
        color: YouthFieldColor.black800,
      ),
    );
  }
}

class _DiaryTextField extends StatelessWidget {
  final TextEditingController controller;
  final int maxLength;
  final String hintText;
  final int minLines;
  final ValueChanged<String>? onChanged;

  const _DiaryTextField({
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
        buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: YouthFieldTextStyle.placeholder.copyWith(
            color: YouthFieldColor.black300,
          ),
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.all(16),
        ),
        style: YouthFieldTextStyle.textCount.copyWith(
          color: YouthFieldColor.black800,
        ),
      ),
    );
  }
}

class _ReadOnlyText extends StatelessWidget {
  final String text;

  const _ReadOnlyText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.isEmpty ? '-' : text,
      style: YouthFieldTextStyle.textCount.copyWith(
        color:
            text.isEmpty ? YouthFieldColor.black300 : YouthFieldColor.black800,
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback? onPressed;

  const _SubmitButton({required this.enabled, this.onPressed});

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
