import 'package:flutter/material.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';
import 'package:youthfield/features/diary/domain/entities/diary_entry.dart';
import 'package:youthfield/features/diary/presentation/pages/diary_detail_view.dart';
import 'package:youthfield/features/diary/presentation/pages/diary_write_view.dart';
import 'package:youthfield/features/diary/presentation/widgets/diary_list_row.dart';

enum DiaryMode { list, write, detail }

const int kDiaryPageSize = 8;
const int kDiaryWindowSize = 5;

class DiaryBody extends StatelessWidget {
  final DiaryMode mode;
  final DiaryEntry? selectedEntry;
  final ValueChanged<DiaryEntry> onEntryTap;
  final ValueChanged<DiaryEntry> onSave;
  final List<DiaryEntry> entries;
  final int currentPage;

  const DiaryBody({
    super.key,
    required this.mode,
    required this.entries,
    required this.onEntryTap,
    required this.onSave,
    required this.currentPage,
    this.selectedEntry,
  });

  @override
  Widget build(BuildContext context) {
    switch (mode) {
      case DiaryMode.list:
        return _DiaryListView(
          entries: entries,
          onEntryTap: onEntryTap,
          currentPage: currentPage,
        );
      case DiaryMode.write:
        return DiaryWriteView(onSave: onSave);
      case DiaryMode.detail:
        if (selectedEntry == null) {
          return _DiaryListView(
            entries: entries,
            onEntryTap: onEntryTap,
            currentPage: currentPage,
          );
        }
        return DiaryDetailView(entry: selectedEntry!);
    }
  }
}

class _DiaryListView extends StatelessWidget {
  final List<DiaryEntry> entries;
  final ValueChanged<DiaryEntry> onEntryTap;
  final int currentPage;

  const _DiaryListView({
    required this.entries,
    required this.onEntryTap,
    required this.currentPage,
  });

  List<DiaryEntry> get _sorted =>
      [...entries]..sort((a, b) => b.date.compareTo(a.date));

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

    final start = currentPage * kDiaryPageSize;
    final end = (start + kDiaryPageSize).clamp(0, sorted.length);
    final pageEntries = sorted.sublist(start, end);

    return Padding(
      padding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 72),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: pageEntries
            .map(
              (entry) =>
                  DiaryListRow(entry: entry, onTap: () => onEntryTap(entry)),
            )
            .toList(),
      ),
    );
  }
}

class DiaryPaginationBar extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int windowStart;
  final ValueChanged<int> onPageTap;
  final VoidCallback onPrevWindow;
  final VoidCallback onNextWindow;

  const DiaryPaginationBar({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.windowStart,
    required this.onPageTap,
    required this.onPrevWindow,
    required this.onNextWindow,
  });

  @override
  Widget build(BuildContext context) {
    final windowEnd = (windowStart + kDiaryWindowSize).clamp(0, totalPages);
    final hasPrevWindow = windowStart > 0;
    final hasNextWindow = windowEnd < totalPages;

    return Container(
      color: YouthFieldColor.background,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (hasPrevWindow) _PageNavButton(label: '<', onTap: onPrevWindow),
          for (int p = windowStart; p < windowEnd; p++)
            _PageNumberButton(
              number: p + 1,
              isActive: p == currentPage,
              onTap: () => onPageTap(p),
            ),
          if (hasNextWindow) _PageNavButton(label: '>', onTap: onNextWindow),
        ],
      ),
    );
  }
}

class _PageNumberButton extends StatelessWidget {
  final int number;
  final bool isActive;
  final VoidCallback onTap;

  const _PageNumberButton({
    required this.number,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isActive ? YouthFieldColor.blue700 : Colors.transparent,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          '$number',
          style: YouthFieldTextStyle.smallButton.copyWith(
            color: isActive ? YouthFieldColor.white : YouthFieldColor.black500,
          ),
        ),
      ),
    );
  }
}

class _PageNavButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PageNavButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        alignment: Alignment.center,
        child: Text(
          label,
          style: YouthFieldTextStyle.smallButton.copyWith(
            color: YouthFieldColor.blue700,
          ),
        ),
      ),
    );
  }
}
