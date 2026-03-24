import 'package:flutter/material.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';
import 'package:youthfield/features/diary/domain/entities/diary_entry.dart';

/// 일지 화면 모드
enum DiaryMode { list, write, detail }

// ── DiaryBody ────────────────────────────────────────────────────────────────

/// 경기/연습 일지 탭의 루트 위젯
///
/// [mode]에 따라 목록·작성·상세 뷰를 전환
/// - [mode] == list   → [_DiaryListView]
/// - [mode] == write  → [_DiaryWriteView]
/// - [mode] == detail → [_DiaryDetailView]
class DiaryBody extends StatelessWidget {
  final DiaryMode mode;

  /// 상세/수정 대상 일지 항목 (write/detail 모드에서 사용)
  final DiaryEntry? selectedEntry;

  /// 목록에서 항목 탭 시 호출 → main_page에서 detail 모드로 전환
  final ValueChanged<DiaryEntry> onEntryTap;

  /// 작성 완료 시 호출 → main_page에서 list 모드로 전환하고 항목 추가
  final ValueChanged<DiaryEntry> onSave;

  /// 현재 관리 중인 일지 목록
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

// ── _DiaryListView ───────────────────────────────────────────────────────────

/// 일지 목록 뷰
///
/// 날짜 내림차순으로 정렬된 일지 항목을 표시
/// 각 행은 날짜 + 내용 미리보기로 구성
class _DiaryListView extends StatelessWidget {
  final List<DiaryEntry> entries;
  final ValueChanged<DiaryEntry> onEntryTap;

  const _DiaryListView({required this.entries, required this.onEntryTap});

  @override
  Widget build(BuildContext context) {
    // 날짜 내림차순 정렬 (최신 일지가 위로)
    final sorted = [...entries]..sort((a, b) => b.date.compareTo(a.date));

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < sorted.length; i++) ...[
          _DiaryListRow(
            entry: sorted[i],
            onTap: () => onEntryTap(sorted[i]),
          ),
          if (i < sorted.length - 1)
            const Divider(height: 1, color: YouthFieldColor.black50),
        ],
      ],
    );
  }
}

/// 목록 단일 행
///
/// 좌측: 날짜 (고정 너비), 우측: 내용 미리보기 (1줄 말줄임)
class _DiaryListRow extends StatelessWidget {
  final DiaryEntry entry;
  final VoidCallback onTap;

  const _DiaryListRow({required this.entry, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: YouthFieldColor.blue50,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            // 날짜 고정 너비
            SizedBox(
              width: 140,
              child: Text(
                entry.formattedDate,
                style: YouthFieldTextStyle.textCount.copyWith(
                  color: YouthFieldColor.black800,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // 내용 미리보기 (1줄 말줄임)
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

// ── _DiaryWriteView ──────────────────────────────────────────────────────────

/// 일지 작성 폼 뷰
///
/// 컨디션 슬라이더, 수면 시간, 경기/연습 내용, 잘한 점, 개선할 점을 입력
/// 내용이 하나라도 입력되면 "작성하기" 버튼 활성화
class _DiaryWriteView extends StatefulWidget {
  final ValueChanged<DiaryEntry> onSave;

  const _DiaryWriteView({required this.onSave});

  @override
  State<_DiaryWriteView> createState() => _DiaryWriteViewState();
}

class _DiaryWriteViewState extends State<_DiaryWriteView> {
  /// 컨디션 슬라이더 값 (0.0 ~ 100.0)
  double _condition = 50;

  /// 수면 시작 시각 (예: "22:30")
  String? _sleepStart;

  /// 기상 시각 (예: "06:30")
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

  /// 내용이 하나라도 입력되었으면 작성하기 버튼 활성화
  bool get _canSave => _contentController.text.trim().isNotEmpty;

  /// 시간 선택 다이얼로그 표시
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
          // 컨디션 슬라이더
          _SectionLabel(label: '컨디션'),
          const SizedBox(height: 8),
          _ConditionSlider(
            value: _condition,
            onChanged: (v) => setState(() => _condition = v),
          ),
          const SizedBox(height: 24),

          // 수면 시간
          _SectionLabel(label: '수면 시간'),
          const SizedBox(height: 8),
          _SleepTimePicker(
            sleepStart: _sleepStart,
            sleepEnd: _sleepEnd,
            onPickStart: () => _pickTime(true),
            onPickEnd: () => _pickTime(false),
          ),
          const SizedBox(height: 24),

          // 경기/연습 내용
          _SectionLabel(label: '경기 / 연습 내용'),
          const SizedBox(height: 8),
          _CharCountTextField(
            controller: _contentController,
            maxLength: 1000,
            hintText: '경기 / 연습 내용을 기록해주세요.',
            minLines: 6,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 24),

          // 잘한 점 / 개선할 점 (좌우 배치)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _SectionLabel(label: '잘한 점'),
                    const SizedBox(height: 8),
                    _CharCountTextField(
                      controller: _goodController,
                      maxLength: 500,
                      hintText: '잘한 점을 기록해주세요.',
                      minLines: 4,
                      onChanged: (_) => setState(() {}),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _SectionLabel(label: '개선할 점'),
                    const SizedBox(height: 8),
                    _CharCountTextField(
                      controller: _improvController,
                      maxLength: 500,
                      hintText: '개선할 점을 기록해주세요.',
                      minLines: 4,
                      onChanged: (_) => setState(() {}),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // 작성하기 버튼
          _SubmitButton(
            enabled: _canSave,
            onPressed: _canSave ? _handleSave : null,
          ),
        ],
      ),
    );
  }
}

// ── _DiaryDetailView ─────────────────────────────────────────────────────────

/// 일지 상세 보기 뷰 (읽기 전용)
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
          // 컨디션 슬라이더 (읽기 전용)
          _SectionLabel(label: '컨디션'),
          const SizedBox(height: 8),
          _ConditionSlider(
            value: entry.condition.toDouble(),
            onChanged: null, // null이면 비활성 (읽기 전용)
          ),
          const SizedBox(height: 24),

          // 수면 시간
          _SectionLabel(label: '수면 시간'),
          const SizedBox(height: 8),
          _ReadOnlySleepTime(
            sleepStart: entry.sleepStart,
            sleepEnd: entry.sleepEnd,
          ),
          const SizedBox(height: 24),

          // 경기/연습 내용
          _SectionLabel(label: '경기 / 연습 내용'),
          const SizedBox(height: 8),
          _ReadOnlyText(text: entry.content),
          const SizedBox(height: 24),

          // 잘한 점 / 개선할 점
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
              const SizedBox(width: 16),
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

// ── 공통 서브 위젯 ────────────────────────────────────────────────────────────

/// 섹션 레이블 텍스트
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

/// 컨디션 슬라이더
///
/// [onChanged]가 null이면 읽기 전용 (상세 뷰에서 사용)
class _ConditionSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double>? onChanged;

  const _ConditionSlider({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 퍼센트 레이블 행
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
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

/// 수면 시간 선택 위젯 (작성 뷰)
///
/// 탭 시 시간 선택 다이얼로그 오픈
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: YouthFieldColor.blue50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          time ?? placeholder,
          style: YouthFieldTextStyle.textCount.copyWith(
            color:
                time != null ? YouthFieldColor.black800 : YouthFieldColor.black300,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _timeBox(sleepStart, '시작시간', onPickStart)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            '—',
            style: YouthFieldTextStyle.textCount.copyWith(
              color: YouthFieldColor.black500,
            ),
          ),
        ),
        Expanded(child: _timeBox(sleepEnd, '기상시간', onPickEnd)),
      ],
    );
  }
}

/// 수면 시간 표시 위젯 (상세 뷰, 읽기 전용)
class _ReadOnlySleepTime extends StatelessWidget {
  final String? sleepStart;
  final String? sleepEnd;

  const _ReadOnlySleepTime({this.sleepStart, this.sleepEnd});

  @override
  Widget build(BuildContext context) {
    final text =
        (sleepStart != null && sleepEnd != null)
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

/// 글자 수 카운터가 있는 멀티라인 텍스트 필드
class _CharCountTextField extends StatelessWidget {
  final TextEditingController controller;
  final int maxLength;
  final String hintText;
  final int minLines;
  final ValueChanged<String>? onChanged;

  const _CharCountTextField({
    required this.controller,
    required this.maxLength,
    required this.hintText,
    this.minLines = 4,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
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
                    null, // 기본 카운터 숨김 (아래 커스텀 표시)
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
        ),
        const SizedBox(height: 4),
        // 커스텀 글자 수 카운터
        Text(
          '${controller.text.length}/$maxLength',
          style: YouthFieldTextStyle.placeholder.copyWith(
            color: YouthFieldColor.black500,
          ),
        ),
      ],
    );
  }
}

/// 읽기 전용 텍스트 표시 위젯 (상세 뷰)
class _ReadOnlyText extends StatelessWidget {
  final String text;

  const _ReadOnlyText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.isEmpty ? '-' : text,
      style: YouthFieldTextStyle.textCount.copyWith(
        color: text.isEmpty ? YouthFieldColor.black300 : YouthFieldColor.black800,
      ),
    );
  }
}

/// 작성하기 버튼
///
/// [enabled]가 false이면 회색 비활성, true이면 파란색 활성
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
