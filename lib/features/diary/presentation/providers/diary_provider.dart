import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youthfield/features/diary/data/repositories/diary_repository_impl.dart';
import 'package:youthfield/features/diary/domain/entities/diary_entry.dart';

class DiaryNotifier extends Notifier<List<DiaryEntry>> {
  @override
  List<DiaryEntry> build() => List.from(diaryMockEntries);

  void add(DiaryEntry entry) {
    state = [entry, ...state];
  }

  List<DiaryEntry> recent({int limit = 3}) {
    final sorted = [...state]..sort((a, b) => b.date.compareTo(a.date));
    return sorted.take(limit).toList();
  }
}

final diaryProvider = NotifierProvider<DiaryNotifier, List<DiaryEntry>>(
  DiaryNotifier.new,
);
