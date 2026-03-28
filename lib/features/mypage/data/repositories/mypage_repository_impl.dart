import 'package:firebase_auth/firebase_auth.dart';
import 'package:youthfield/core/services/user_session.dart';
import 'package:youthfield/features/diary/data/diary_store.dart';
import 'package:youthfield/features/diary/domain/entities/diary_entry.dart';
import 'package:youthfield/features/mypage/domain/entities/player_stats.dart';
import 'package:youthfield/features/mypage/domain/entities/recent_player.dart';
import 'package:youthfield/features/mypage/domain/entities/user_profile.dart';
import 'package:youthfield/features/mypage/domain/entities/user_type.dart';
import 'package:youthfield/features/mypage/domain/entities/watched_skill.dart';
import 'package:youthfield/features/mypage/domain/repositories/mypage_repository.dart';

List<DiaryEntry> _mockDiaries() => [
  DiaryEntry(
    id: 'diary_1',
    date: DateTime(2026, 3, 5),
    condition: 80,
    content: '전반 30분에 교체로 들어가게 됐고, 내가 상대방인 것 만큼 경기는 잘 풀리지 않았다. 그래도 어시를 하나...',
    goodPoints: '',
    improvements: '',
  ),
  DiaryEntry(
    id: 'diary_2',
    date: DateTime(2026, 3, 4),
    condition: 70,
    content: '전반 30분에 교체로 들어가게 됐고, 내가 상대방인 것 만큼 경기는 잘 풀리지 않았다. 그래도 어시를 하나...',
    goodPoints: '',
    improvements: '',
  ),
  DiaryEntry(
    id: 'diary_3',
    date: DateTime(2026, 3, 4),
    condition: 65,
    content: '전반 30분에 교체로 들어가게 됐고, 내가 상대방인 것 만큼 경기는 잘 풀리지 않았다. 그래도 어시를 하나...',
    goodPoints: '',
    improvements: '',
  ),
];

const _mockWatchedSkills = [
  WatchedSkill(id: 'skill_1', title: '드리블', subtitle: '상대에게 빼기지 않으면서 도는 방법'),
  WatchedSkill(id: 'skill_2', title: '드리블', subtitle: '상대에게 빼기지 않으면서 도는 방법'),
];

const _mockRecentPlayers = [
  RecentPlayer(
    name: '박지훈',
    school: '부산체고',
    location: '부산광역시 해운대구',
    position: 'GK',
    ageGroup: 'U-15',
    number: 1,
  ),
  RecentPlayer(
    name: '이서준',
    school: '오산고',
    location: '경기도 오산시 원동',
    position: 'DF',
    ageGroup: 'U-17',
    number: 4,
  ),
  RecentPlayer(
    name: '한승민',
    school: '수원매탄고',
    location: '경기도 수원시 영통구',
    position: 'DF',
    ageGroup: 'U-15',
    number: 5,
  ),
  RecentPlayer(
    name: '신재민',
    school: '대구체고',
    location: '대구광역시 달서구',
    position: 'DF',
    ageGroup: 'U-16',
    number: 6,
  ),
];

class MypageRepositoryImpl implements MypageRepository {
  @override
  Future<UserProfile> getMyProfile() async {
    return PlayerProfile(
      id: 'user_1',
      name: '백가온',
      position: 'FORWARD',
      school: '보인고',
      birthDate: DateTime(2006, 1, 23),
      seasonStats: const PlayerStats(
        appearances: 20,
        goals: 3,
        assists: 10,
        yellowCards: 0,
        redCards: 0,
      ),
      nationalStats: const PlayerStats(
        appearances: 2,
        goals: 0,
        assists: 103,
        yellowCards: 0,
        redCards: 0,
      ),
      watchedSkills: _mockWatchedSkills,
      recentDiaries: _mockDiaries(),
    );
  }
}

class MypageRepositoryImplStaff implements MypageRepository {
  @override
  Future<UserProfile> getMyProfile() async {
    return StaffProfile(
      id: 'staff_1',
      name: '백가온',
      teamRole: '부산아이파크U15감독',
      watchedSkills: _mockWatchedSkills,
      recentPlayers: _mockRecentPlayers,
      recentDiaries: _mockDiaries(),
    );
  }
}

class MypageRepositoryImplGeneral implements MypageRepository {
  @override
  Future<UserProfile> getMyProfile() async {
    return GeneralProfile(
      id: 'general_1',
      name: '백가온',
      watchedSkills: _mockWatchedSkills,
      recentPlayers: _mockRecentPlayers,
      recentDiaries: _mockDiaries(),
    );
  }
}

class UserSessionRepository implements MypageRepository {
  @override
  Future<UserProfile> getMyProfile() async {
    final s = UserSession();
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final name = (s.name?.isNotEmpty == true)
        ? s.name!
        : (firebaseUser?.displayName ?? '');

    final bytes = s.profileImageBytes;
    final photoUrl = (bytes == null) ? firebaseUser?.photoURL : null;

    switch (s.userType ?? UserType.general) {
      case UserType.player:
        DateTime birthDate;
        try {
          final parts = (s.birthdate ?? '2000.01.01').split('.');
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
          position: s.position ?? 'FW',
          school: s.team ?? '',
          birthDate: birthDate,
          resolve: s.resolve,
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
          recentDiaries: DiaryStore().recent(),
        );
      case UserType.staff:
        final team = s.team ?? '';
        final roleLabel = s.staffRole;
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
          recentDiaries: DiaryStore().recent(),
        );
      case UserType.general:
        return GeneralProfile(
          id: 'session',
          name: name,
          profileImageBytes: bytes,
          profileImageUrl: photoUrl,
          watchedSkills: const [],
          recentPlayers: const [],
          recentDiaries: DiaryStore().recent(),
        );
    }
  }
}
