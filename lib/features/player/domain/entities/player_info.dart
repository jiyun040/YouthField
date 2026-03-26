import 'package:youthfield/features/mypage/domain/entities/player_stats.dart';

class PlayerInfo {
  final String name;
  final String school;
  final String location;
  final String position;
  final String ageGroup;
  final int number;
  final String birthdate;
  final PlayerStats seasonStats;
  final PlayerStats nationalStats;
  final String? imageUrl;

  const PlayerInfo({
    required this.name,
    required this.school,
    required this.location,
    required this.position,
    required this.ageGroup,
    required this.number,
    required this.birthdate,
    required this.seasonStats,
    required this.nationalStats,
    this.imageUrl,
  });
}
