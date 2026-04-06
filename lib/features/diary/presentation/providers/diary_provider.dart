import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youthfield/features/diary/domain/entities/diary_entry.dart';

const _kDiaryKey = 'diary_entries';

class DiaryNotifier extends Notifier<List<DiaryEntry>> {
  @override
  List<DiaryEntry> build() {
    Future.microtask(_load);
    return [];
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_kDiaryKey) ?? [];
    final entries = raw
        .map(DiaryEntry.fromJsonString)
        .whereType<DiaryEntry>()
        .toList();
    if (entries.isNotEmpty) {
      state = entries;
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _kDiaryKey,
      state.map((e) => e.toJsonString()).toList(),
    );
  }

  Future<void> add(DiaryEntry entry) async {
    state = [entry, ...state];
    await _save();
  }

  List<DiaryEntry> recent({int limit = 3}) {
    final sorted = [...state]..sort((a, b) => b.date.compareTo(a.date));
    return sorted.take(limit).toList();
  }
}

final diaryProvider = NotifierProvider<DiaryNotifier, List<DiaryEntry>>(
  DiaryNotifier.new,
);
