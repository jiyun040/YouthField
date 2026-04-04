import 'package:youthfield/features/diary/data/repositories/diary_repository_impl.dart';
import 'package:youthfield/features/diary/domain/entities/diary_entry.dart';

class DiaryStore {
  DiaryStore._();

  static final DiaryStore _instance = DiaryStore._();

  factory DiaryStore() => _instance;

  final List<DiaryEntry> _entries = List.from(diaryMockEntries);

  List<DiaryEntry> get entries => List.unmodifiable(_entries);

  void add(DiaryEntry entry) {
    _entries.insert(0, entry);
  }

  List<DiaryEntry> recent({int limit = 3}) {
    final sorted = [..._entries]..sort((a, b) => b.date.compareTo(a.date));
    return sorted.take(limit).toList();
  }
}
