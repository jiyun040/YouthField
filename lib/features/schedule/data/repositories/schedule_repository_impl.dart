import '../../domain/entities/schedule.dart';

const scheduleMockEvents = [
  ScheduleEvent(
    title: '2026년도 부산 초,중학생체육대회 (구 소년체전 선발전)',
    dateRange: '2026.03.05 ~ 03.13',
    venue: '기장월드컵빌리지 인조B',
    matches: [
      ScheduleMatch(homeTeam: '부산아이파크U15낙동중', awayTeam: '서울목동중', date: '03.05(목)', time: '12:00', venue: '인조B', score: '0:0'),
      ScheduleMatch(homeTeam: '부산아이파크U15낙동중', awayTeam: '서울목동중', date: '03.05(목)', time: '14:00', venue: '인조B', score: '0:2'),
      ScheduleMatch(homeTeam: '부산아이파크U15낙동중', awayTeam: '서울목동중', date: '03.07(토)', time: '10:00', venue: '인조B'),
      ScheduleMatch(homeTeam: '부산아이파크U15낙동중', awayTeam: '서울목동중', date: '03.07(토)', time: '12:00', venue: '인조B'),
      ScheduleMatch(homeTeam: '부산아이파크U15낙동중', awayTeam: '서울목동중', date: '03.07(토)', time: '14:00', venue: '인조B'),
    ],
  ),
  ScheduleEvent(
    title: '2026 전국 U-15 클럽챔피언십',
    dateRange: '2026.04.01 ~ 04.10',
    venue: '서울 월드컵경기장 보조구장',
    matches: [
      ScheduleMatch(homeTeam: '서울목동중', awayTeam: '수원매탄중', date: '04.01(수)', time: '10:00', venue: '보조구장'),
      ScheduleMatch(homeTeam: '대구오성중', awayTeam: '부산아이파크U15낙동중', date: '04.01(수)', time: '13:00', venue: '보조구장'),
      ScheduleMatch(homeTeam: '서울목동중', awayTeam: '대구오성중', date: '04.03(금)', time: '14:00', venue: '보조구장'),
      ScheduleMatch(homeTeam: '수원매탄중', awayTeam: '부산아이파크U15낙동중', date: '04.05(일)', time: '11:00', venue: '보조구장'),
    ],
  ),
  ScheduleEvent(
    title: '2026 경기도 유소년 축구 리그 1라운드',
    dateRange: '2026.04.15 ~ 04.20',
    venue: '수원종합운동장 B구장',
    matches: [
      ScheduleMatch(homeTeam: '수원매탄중', awayTeam: '분당FC중', date: '04.15(수)', time: '10:00', venue: 'B구장'),
      ScheduleMatch(homeTeam: '성남중앙중', awayTeam: '안양FC중', date: '04.15(수)', time: '13:00', venue: 'B구장'),
      ScheduleMatch(homeTeam: '수원매탄중', awayTeam: '성남중앙중', date: '04.17(금)', time: '11:00', venue: 'B구장'),
    ],
  ),
  ScheduleEvent(
    title: '2026 전국소년체육대회 예선전',
    dateRange: '2026.05.02 ~ 05.08',
    venue: '대전월드컵경기장 인조잔디',
    matches: [
      ScheduleMatch(homeTeam: '부산FC중', awayTeam: '대전시티즌중', date: '05.02(토)', time: '09:00', venue: '인조잔디'),
      ScheduleMatch(homeTeam: '서울목동중', awayTeam: '인천U15중', date: '05.02(토)', time: '11:30', venue: '인조잔디'),
      ScheduleMatch(homeTeam: '대전시티즌중', awayTeam: '서울목동중', date: '05.05(화)', time: '14:00', venue: '인조잔디'),
    ],
  ),
  ScheduleEvent(
    title: '2026 AFC U-17 아시안컵 국내 선발전',
    dateRange: '2026.05.20 ~ 05.25',
    venue: '파주 국가대표 트레이닝센터',
    matches: [
      ScheduleMatch(homeTeam: '대표팀 A조', awayTeam: '대표팀 B조', date: '05.20(수)', time: '15:00', venue: 'NFC'),
      ScheduleMatch(homeTeam: '대표팀 C조', awayTeam: '대표팀 D조', date: '05.21(목)', time: '15:00', venue: 'NFC'),
      ScheduleMatch(homeTeam: '대표팀 A조', awayTeam: '대표팀 C조', date: '05.23(토)', time: '16:00', venue: 'NFC'),
    ],
  ),
];
