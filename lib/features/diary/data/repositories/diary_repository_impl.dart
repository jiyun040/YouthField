import '../../domain/entities/diary_entry.dart';

/// 경기/연습 일지 목 데이터
/// 실제 서비스에서는 로컬 DB 또는 API로 교체
final List<DiaryEntry> diaryMockEntries = [
  DiaryEntry(
    id: '1',
    date: DateTime(2026, 3, 5),
    condition: 65,
    sleepStart: '23:00',
    sleepEnd: '06:30',
    content:
        '전반 30분에 교체로 들어가서 뛰었고, 내가 상대방인 것 만큼 경기는 잘 볼리지 않았다. 그래도 어서는 마니라도 달리자는 생각으로 끝까지 뛰었다. 후반에는 페이스가 조금 올라온 것 같아서 만족스러웠다.',
    goodPoints: '마지막까지 포기하지 않고 달린 것',
    improvements: '전반전 첫 교체 투입 시 포지셔닝 빠르게 잡기',
  ),
  DiaryEntry(
    id: '2',
    date: DateTime(2026, 3, 4),
    condition: 80,
    sleepStart: '22:30',
    sleepEnd: '07:00',
    content:
        '오늘 연습은 패스 정확도를 중점적으로 훈련했다. 짧은 패스는 잘 됐는데 긴 패스는 아직 힘이 조금 부족하다. 코치님이 왼발도 사용하라고 하셔서 의식적으로 노력해봤다.',
    goodPoints: '짧은 패스 정확도 향상',
    improvements: '왼발 롱패스 연습 더 필요',
  ),
  DiaryEntry(
    id: '3',
    date: DateTime(2026, 3, 3),
    condition: 50,
    sleepStart: '23:30',
    sleepEnd: '07:30',
    content:
        '몸 상태가 좀 좋지 않아서 컨디션이 낮았다. 그래도 팀 훈련은 빠지지 않고 참여했다. 수비 훈련이 메인이었고, 1:1 상황에서 중심 잡는 연습을 했다.',
    goodPoints: '아픈 상황에서도 훈련 참가',
    improvements: '1:1 수비 시 거리 유지',
  ),
  DiaryEntry(
    id: '4',
    date: DateTime(2026, 3, 2),
    condition: 90,
    sleepStart: '22:00',
    sleepEnd: '06:00',
    content:
        '오늘은 정말 몸 상태가 최고였다. 드리블 훈련에서 새로운 기술을 배웠고 생각보다 잘 따라졌다. 미니 게임에서 2골을 넣어서 기분이 좋았다.',
    goodPoints: '적극적인 공격 가담, 2골',
    improvements: '슈팅 시 발목 고정을 더 신경쓰기',
  ),
  DiaryEntry(
    id: '5',
    date: DateTime(2026, 3, 1),
    condition: 70,
    sleepStart: '23:00',
    sleepEnd: '06:30',
    content:
        '3월 첫날 훈련. 새 시즌을 시작하는 느낌이 들어서 동기부여가 됐다. 팀 전체적으로 사기가 높았고 훈련 강도도 높았다. 체력 훈련 위주였는데 꽤 힘들었다.',
    goodPoints: '체력 훈련 완주',
    improvements: '후반부 스프린트 체력 보강',
  ),
  DiaryEntry(
    id: '6',
    date: DateTime(2026, 2, 28),
    condition: 60,
    sleepStart: '23:00',
    sleepEnd: '07:00',
    content:
        '2월 마지막 날 연습 경기. 상대팀이 강해서 쉽지 않았다. 우리 팀 조직력이 아직 부족한 것을 느꼈다. 하지만 계속 소통하면서 끝까지 버텼다.',
    goodPoints: '팀원들과 소통하며 경기 진행',
    improvements: '빌드업 시 공간 활용',
  ),
  DiaryEntry(
    id: '7',
    date: DateTime(2026, 2, 27),
    condition: 75,
    sleepStart: '22:30',
    sleepEnd: '06:30',
    content:
        '피지컬 트레이닝 위주의 하루였다. 웨이트와 달리기를 번갈아 가며 했는데 체력이 많이 올라온 것 같다. 코어 운동도 추가로 진행했다.',
    goodPoints: '웨이트 개인 최고 중량 경신',
    improvements: '달리기 자세 개선 필요',
  ),
  DiaryEntry(
    id: '8',
    date: DateTime(2026, 2, 26),
    condition: 85,
    sleepStart: '22:00',
    sleepEnd: '06:00',
    content:
        '세트피스 훈련이 메인이었다. 코너킥과 프리킥 루틴을 새로 짜서 연습했다. 우리 팀이 세트피스에서 강해지면 승률이 많이 올라갈 것 같다.',
    goodPoints: '세트피스 루틴 빠르게 숙지',
    improvements: '프리킥 키커로서 정확도 향상',
  ),
  DiaryEntry(
    id: '9',
    date: DateTime(2026, 2, 25),
    condition: 55,
    sleepStart: '00:00',
    sleepEnd: '07:00',
    content:
        '전날 늦게 잠들어서 피로가 조금 남아있었다. 그래도 패스 훈련은 제대로 참여했다. 볼 트래핑 연습에서 코치님께 칭찬을 받았다.',
    goodPoints: '볼 트래핑 정확도',
    improvements: '수면 관리 철저히',
  ),
  DiaryEntry(
    id: '10',
    date: DateTime(2026, 2, 24),
    condition: 78,
    sleepStart: '22:30',
    sleepEnd: '06:30',
    content:
        '팀 전술 회의 후 훈련. 감독님이 새로운 포메이션을 도입하셨다. 4-3-3에서 4-2-3-1로 변경. 내 역할이 더 넓어질 것 같아서 긴장도 되고 기대도 된다.',
    goodPoints: '새 전술에 빠른 적응',
    improvements: '중앙 미드필더 역할 숙지',
  ),
];
