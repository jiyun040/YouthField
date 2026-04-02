import 'package:firebase_auth/firebase_auth.dart';
import 'package:youthfield/core/providers/user_session_provider.dart';
import 'package:youthfield/features/diary/domain/entities/diary_entry.dart';
import 'package:youthfield/features/mypage/domain/entities/player_stats.dart';
import 'package:youthfield/features/mypage/domain/entities/user_profile.dart';
import 'package:youthfield/features/mypage/domain/entities/user_type.dart';
import 'package:youthfield/features/mypage/domain/repositories/mypage_repository.dart';

class UserSessionRepository implements MypageRepository {
  final UserSessionState session;
  final List<DiaryEntry> diaries;

  const UserSessionRepository({
    required this.session,
    required this.diaries,
  });

  @override
  Future<UserProfile> getMyProfile() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final name = (session.name?.isNotEmpty == true)
        ? session.name!
        : (firebaseUser?.displayName ?? '');

    final bytes = session.profileImageBytes;
    final photoUrl = (bytes == null) ? firebaseUser?.photoURL : null;

    final recentDiaries = ([...diaries]
          ..sort((a, b) => b.date.compareTo(a.date)))
        .take(3)
        .toList();

    switch (session.userType ?? UserType.general) {
      case UserType.player:
        DateTime birthDate;
        try {
          final parts = (session.birthdate ?? '2000.01.01').split('.');
          birthDate = DateTime(
            int.parse(parts[0]),
            int.parse(parts[1]),
            int.parse(parts[2]),
          );
        } catch (_) {
          birthDate = DateTime(2000);
        }
        final resolvedId = firebaseUser?.uid ?? 'session';
        return PlayerProfile(
          id: resolvedId,
          name: name,
          profileImageBytes: bytes,
          profileImageUrl: photoUrl,
          position: session.position ?? 'FW',
          school: session.team ?? '',
          birthDate: birthDate,
          resolve: session.resolve,
          seasonStats: const PlayerStats(
            appearances: 0,
            goals: 0,
            assists: 0,
            yellowCards: 0,
            redCards: 0,
          ),
          nationalStats: const PlayerStats(
            appearances: 0,
            goals: 0,
            assists: 0,
            yellowCards: 0,
            redCards: 0,
          ),
          watchedSkills: const [],
          recentDiaries: recentDiaries,
        );
      case UserType.staff:
        final team = session.team ?? '';
        final roleLabel = session.staffRole;
        final teamRole = (team.isNotEmpty && roleLabel != null)
            ? '$team $roleLabel'
            : team.isNotEmpty
                ? team
                : (roleLabel ?? '');
        return StaffProfile(
          id: 'session',
          name: name,
          profileImageBytes: bytes,
          profileImageUrl: photoUrl,
          teamRole: teamRole,
          watchedSkills: const [],
          recentPlayers: const [],
          recentDiaries: recentDiaries,
        );
      case UserType.general:
        return GeneralProfile(
          id: 'session',
          name: name,
          profileImageBytes: bytes,
          profileImageUrl: photoUrl,
          watchedSkills: const [],
          recentPlayers: const [],
          recentDiaries: recentDiaries,
        );
    }
  }
}
