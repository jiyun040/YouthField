import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:youthfield/features/diary/domain/entities/diary_entry.dart';

const _kDiaryBox = 'diary';

Box<String> get _box => Hive.box<String>(_kDiaryBox);

class DiaryNotifier extends Notifier<List<DiaryEntry>> {
  @override
  List<DiaryEntry> build() {
    return _box.values
        .map(DiaryEntry.fromJsonString)
        .whereType<DiaryEntry>()
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> add(DiaryEntry entry) async {
    await _box.put(entry.id, entry.toJsonString());
    state = [entry, ...state];
  }

  List<DiaryEntry> recent({int limit = 3}) {
    return state.take(limit).toList();
  }
}

final diaryProvider = NotifierProvider<DiaryNotifier, List<DiaryEntry>>(
  DiaryNotifier.new,
);
