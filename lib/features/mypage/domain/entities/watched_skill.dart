class WatchedSkill {
  final String id;
  final String title;
  final String subtitle;
  final String? thumbnailUrl;

  const WatchedSkill({
    required this.id,
    required this.title,
    required this.subtitle,
    this.thumbnailUrl,
  });
}
