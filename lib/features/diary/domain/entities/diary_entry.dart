import 'dart:convert';

class DiaryEntry {

  final String id;

  final DateTime date;

  final int condition;

  final String? sleepStart;

  final String? sleepEnd;

  final String content;

  final String goodPoints;

  final String improvements;

  const DiaryEntry({
    required this.id,
    required this.date,
    required this.condition,
    this.sleepStart,
    this.sleepEnd,
    required this.content,
    this.goodPoints = '',
    this.improvements = '',
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'condition': condition,
    'sleepStart': sleepStart,
    'sleepEnd': sleepEnd,
    'content': content,
    'goodPoints': goodPoints,
    'improvements': improvements,
  };

  String toJsonString() => jsonEncode(toJson());

  factory DiaryEntry.fromJson(Map<String, dynamic> json) => DiaryEntry(
    id: json['id'] as String,
    date: DateTime.parse(json['date'] as String),
    condition: (json['condition'] as num).toInt(),
    sleepStart: json['sleepStart'] as String?,
    sleepEnd: json['sleepEnd'] as String?,
    content: json['content'] as String? ?? '',
    goodPoints: json['goodPoints'] as String? ?? '',
    improvements: json['improvements'] as String? ?? '',
  );

  static DiaryEntry? fromJsonString(String s) {
    try {
      return DiaryEntry.fromJson(jsonDecode(s) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  String get formattedDate {
    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    final wd = weekdays[date.weekday - 1];
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '${date.year}.$m.$d ($wd)';
  }
}
