import 'dart:typed_data';

import 'package:youthfield/features/diary/domain/entities/diary_entry.dart';
import 'package:youthfield/features/mypage/domain/entities/player_stats.dart';
import 'package:youthfield/features/mypage/domain/entities/recent_player.dart';
import 'package:youthfield/features/mypage/domain/entities/watched_skill.dart';

sealed class UserProfile {
  final String id;
  final String name;
  final String? profileImageUrl;
  final Uint8List? profileImageBytes;

  const UserProfile({
    required this.id,
    required this.name,
    this.profileImageUrl,
    this.profileImageBytes,
  });
}

class PlayerProfile extends UserProfile {
  final String position;
  final String school;
  final DateTime birthDate;
  final String? resolve;
  final PlayerStats seasonStats;
  final PlayerStats nationalStats;
  final List<WatchedSkill> watchedSkills;
  final List<RecentPlayer> recentPlayers;
  final List<DiaryEntry> recentDiaries;

  const PlayerProfile({
    required super.id,
    required super.name,
    super.profileImageUrl,
    super.profileImageBytes,
    required this.position,
    required this.school,
    required this.birthDate,
    this.resolve,
    required this.seasonStats,
    required this.nationalStats,
    required this.watchedSkills,
    this.recentPlayers = const [],
    required this.recentDiaries,
  });
}

class StaffProfile extends UserProfile {
  final String teamRole;
  final List<WatchedSkill> watchedSkills;
  final List<RecentPlayer> recentPlayers;
  final List<DiaryEntry> recentDiaries;

  const StaffProfile({
    required super.id,
    required super.name,
    super.profileImageUrl,
    super.profileImageBytes,
    required this.teamRole,
    required this.watchedSkills,
    required this.recentPlayers,
    this.recentDiaries = const [],
  });
}

class GeneralProfile extends UserProfile {
  final List<WatchedSkill> watchedSkills;
  final List<RecentPlayer> recentPlayers;
  final List<DiaryEntry> recentDiaries;

  const GeneralProfile({
    required super.id,
    required super.name,
    super.profileImageUrl,
    super.profileImageBytes,
    required this.watchedSkills,
    required this.recentPlayers,
    this.recentDiaries = const [],
  });
}
