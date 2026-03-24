/// 경기/연습 일지 단일 항목 엔티티
class DiaryEntry {
  /// 고유 식별자
  final String id;

  /// 일지 작성 날짜
  final DateTime date;

  /// 컨디션 수치 (0 ~ 100)
  final int condition;

  /// 수면 시작 시각 (예: "22:30"), 미입력 시 null
  final String? sleepStart;

  /// 기상 시각 (예: "06:30"), 미입력 시 null
  final String? sleepEnd;

  /// 경기/연습 내용 (최대 1000자)
  final String content;

  /// 잘한 점 (최대 500자)
  final String goodPoints;

  /// 개선할 점 (최대 500자)
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

  /// 날짜를 "yyyy.MM.dd (요일)" 형식으로 반환
  /// 예: "2026.03.05 (목)"
  String get formattedDate {
    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    final wd = weekdays[date.weekday - 1];
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '${date.year}.$m.$d ($wd)';
  }
}
