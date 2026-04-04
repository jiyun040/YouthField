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

  String get formattedDate {
    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    final wd = weekdays[date.weekday - 1];
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '${date.year}.$m.$d ($wd)';
  }
}
