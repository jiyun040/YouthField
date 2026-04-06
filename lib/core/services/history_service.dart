import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:youthfield/features/mypage/domain/entities/recent_player.dart';
import 'package:youthfield/features/mypage/domain/entities/watched_skill.dart';

class HistoryService {
  static const _kHistoryBox = 'history';
  static const _skillsKey = 'history_watched_skills';
  static const _playersKey = 'history_recent_players';
  static const _maxItems = 50;

  static Box<String> get _box => Hive.box<String>(_kHistoryBox);

  static Future<void> addWatchedSkill(WatchedSkill skill) async {
    final list = await getWatchedSkills();
    final filtered = list.where((s) => s.id != skill.id).toList();
    filtered.insert(0, skill);
    final trimmed = filtered.take(_maxItems).toList();
    await _box.put(
      _skillsKey,
      jsonEncode(
        trimmed
            .map(
              (s) => {
                'id': s.id,
                'title': s.title,
                'subtitle': s.subtitle,
                'thumbnailUrl': s.thumbnailUrl,
              },
            )
            .toList(),
      ),
    );
  }

  static Future<List<WatchedSkill>> getWatchedSkills() async {
    final raw = _box.get(_skillsKey);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list
          .map(
            (e) => WatchedSkill(
              id: e['id'] as String,
              title: e['title'] as String,
              subtitle: e['subtitle'] as String,
              thumbnailUrl: e['thumbnailUrl'] as String?,
            ),
          )
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> addRecentPlayer(RecentPlayer player) async {
    final list = await getRecentPlayers();
    final filtered = list.where((p) => p.name != player.name).toList();
    filtered.insert(0, player);
    final trimmed = filtered.take(_maxItems).toList();
    await _box.put(
      _playersKey,
      jsonEncode(
        trimmed
            .map(
              (p) => {
                'name': p.name,
                'school': p.school,
                'location': p.location,
                'position': p.position,
                'ageGroup': p.ageGroup,
                'number': p.number,
                'imageUrl': p.imageUrl,
              },
            )
            .toList(),
      ),
    );
  }

  static Future<List<RecentPlayer>> getRecentPlayers() async {
    final raw = _box.get(_playersKey);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list
          .map(
            (e) => RecentPlayer(
              name: e['name'] as String,
              school: e['school'] as String,
              location: e['location'] as String,
              position: e['position'] as String,
              ageGroup: e['ageGroup'] as String,
              number: e['number'] as int,
              imageUrl: e['imageUrl'] as String?,
            ),
          )
          .toList();
    } catch (_) {
      return [];
    }
  }
}
