import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';
import 'package:youthfield/features/schedule/domain/entities/schedule.dart';

/// 경기 상세 페이지
///
/// [ScheduleDetailPage]의 [MatchRow] 탭 시 [Navigator.push]로 진입
/// 구성: 상단 앱바([_MatchDetailHeader]) + 스크롤 영역
///   - 경기 결과·스코어 카드([_ScoreCard])
///   - 경기 이벤트 목록([_EventsSection]) — 이벤트가 있을 때만 표시
///   - 출전 선수 라인업([_LineupSection]) — 선수 데이터가 있을 때만 표시
class MatchDetailPage extends StatelessWidget {
  /// 표시할 경기 데이터
  final ScheduleMatch match;

  /// 상단 앱바에 표시할 대회·리그 이름
  final String eventTitle;

  const MatchDetailPage({
    super.key,
    required this.match,
    required this.eventTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YouthFieldColor.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // 뒤로가기 버튼 + "경기 상세" 타이틀 앱바
            _MatchDetailHeader(eventTitle: eventTitle),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 팀명·스코어·전후반 점수 표시
                    _ScoreCard(match: match),
                    // 득점·카드 이벤트 목록 (이벤트 없으면 섹션 자체 숨김)
                    if (match.events.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _EventsSection(events: match.events),
                    ],
                    // 출전 선수 라인업 (선수 데이터 없으면 섹션 자체 숨김)
                    if (match.homePlayers.isNotEmpty ||
                        match.awayPlayers.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _LineupSection(
                        homeTeam: match.homeTeam,
                        awayTeam: match.awayTeam,
                        homePlayers: match.homePlayers,
                        awayPlayers: match.awayPlayers,
                      ),
                    ],
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 경기 상세 페이지의 커스텀 앱바
///
/// - 좌측: 뒤로가기 버튼 ([Navigator.pop])
/// - 중앙: "경기 상세" 고정 타이틀
/// - Stack 레이아웃으로 타이틀이 항상 정중앙에 위치하도록 처리
class _MatchDetailHeader extends StatelessWidget {
  /// 대회·리그 이름 (현재 UI에서는 미사용, 확장 시 활용 가능)
  final String eventTitle;

  const _MatchDetailHeader({required this.eventTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      color: YouthFieldColor.background,
      child: Stack(
        children: [
          // 좌측 뒤로가기 버튼
          Positioned(
            left: 8,
            top: 0,
            bottom: 0,
            child: Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(
                  Symbols.chevron_left,
                  color: YouthFieldColor.blue700,
                  size: 32,
                ),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          // 중앙 타이틀
          Center(
            child: Text(
              '경기 상세',
              style: YouthFieldTextStyle.body4.copyWith(
                color: YouthFieldColor.black800,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 경기 결과 카드
///
/// - score가 있으면: 팀명 + 최종 스코어 + 전·후반 점수 표시
/// - score가 없으면: 팀명 + "VS" + 경기 날짜·시간·장소 표시
class _ScoreCard extends StatelessWidget {
  final ScheduleMatch match;

  const _ScoreCard({required this.match});

  @override
  Widget build(BuildContext context) {
    // score 문자열이 비어있지 않으면 결과 있음으로 판단
    final hasResult = (match.score?.trim().isNotEmpty ?? false);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: YouthFieldColor.background,
      ),
      child: Column(
        children: [
          Text(
            '경기 결과',
            style: YouthFieldTextStyle.placeholder.copyWith(
              color: YouthFieldColor.black500,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  match.homeTeam,
                  textAlign: TextAlign.center,
                  style: YouthFieldTextStyle.body4.copyWith(
                    color: YouthFieldColor.blue700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  hasResult ? match.score!.trim() : 'VS',
                  style: YouthFieldTextStyle.title4.copyWith(
                    color: hasResult
                        ? YouthFieldColor.black800
                        : YouthFieldColor.black500,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  match.awayTeam,
                  textAlign: TextAlign.center,
                  style: YouthFieldTextStyle.body4.copyWith(
                    color: YouthFieldColor.black800,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          if (hasResult) ...[
            const SizedBox(height: 16),
            const Divider(color: YouthFieldColor.black50),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _HalfScore(label: '전반전', score: match.firstHalfScore),
                const SizedBox(width: 32),
                _HalfScore(label: '후반전', score: match.secondHalfScore),
              ],
            ),
          ] else ...[
            const SizedBox(height: 12),
            Text(
              '${match.date}  ${match.time}  |  ${match.venue}',
              textAlign: TextAlign.center,
              style: YouthFieldTextStyle.placeholder.copyWith(
                color: YouthFieldColor.black500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// 전반전 / 후반전 스코어 한 칸
///
/// [label]에 "전반전" 또는 "후반전", [score]가 null이면 "-" 표시
class _HalfScore extends StatelessWidget {
  final String label;
  final String? score;

  const _HalfScore({required this.label, required this.score});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: YouthFieldTextStyle.placeholder.copyWith(
            color: YouthFieldColor.black500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          score ?? '-',
          style: YouthFieldTextStyle.body4.copyWith(
            color: YouthFieldColor.black800,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

/// 경기 이벤트 목록 섹션
///
/// 이벤트를 발생 시각(분) 기준 오름차순으로 정렬 후 [_EventRow]로 렌더링
/// 각 행 사이에 얇은 구분선(Divider) 삽입
class _EventsSection extends StatelessWidget {
  final List<MatchEvent> events;

  const _EventsSection({required this.events});

  @override
  Widget build(BuildContext context) {
    // 분(minute) 기준 오름차순 정렬 (원본 리스트 변경 방지를 위해 복사본 사용)
    final sorted = [...events]..sort((a, b) => a.minute.compareTo(b.minute));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '경기 이벤트',
          style: YouthFieldTextStyle.body4.copyWith(
            color: YouthFieldColor.black800,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        Column(
          children: sorted.asMap().entries.map((entry) {
            final i = entry.key;
            final e = entry.value;
            return Column(
              children: [
                _EventRow(event: e),
                if (i < sorted.length - 1)
                  const Divider(height: 1, color: YouthFieldColor.black50),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}

/// 경기 이벤트 단일 행
///
/// 레이아웃: [분] [아이콘] [선수명 or 교체 텍스트]
/// - 홈팀 이벤트: 선수명 파란색(blue700)
/// - 어웨이팀 이벤트: 선수명 검정(black800)
/// - 교체(substitution)는 "OUT 선수명      IN 선수명" 형식으로 표시
class _EventRow extends StatelessWidget {
  final MatchEvent event;

  const _EventRow({required this.event});

  /// 이벤트 유형에 맞는 아이콘 또는 카드 위젯 반환
  Widget _buildIcon() {
    switch (event.type) {
      case MatchEventType.goal:
        return const Icon(
          Symbols.sports_soccer,
          color: YouthFieldColor.blue700,
          size: 20,
        );
      case MatchEventType.yellowCard:
        // 경고 카드: 노란 사각형
        return Container(
          width: 14,
          height: 18,
          decoration: BoxDecoration(
            color: const Color(0xFFFFC107),
            borderRadius: BorderRadius.circular(2),
          ),
        );
      case MatchEventType.redCard:
        // 퇴장 카드: 빨간 사각형
        return Container(
          width: 14,
          height: 18,
          decoration: BoxDecoration(
            color: YouthFieldColor.danger,
            borderRadius: BorderRadius.circular(2),
          ),
        );
      case MatchEventType.substitution:
        return const Icon(
          Symbols.swap_vert,
          color: YouthFieldColor.black500,
          size: 20,
        );
    }
  }

  /// 이벤트 유형에 맞는 텍스트 레이블 반환
  /// 교체의 경우 OUT/IN 선수를 함께 표시
  String get _label {
    switch (event.type) {
      case MatchEventType.goal:
        return '골';
      case MatchEventType.yellowCard:
        return '경고';
      case MatchEventType.redCard:
        return '퇴장';
      case MatchEventType.substitution:
        return 'OUT ${event.playerName}      IN ${event.subPlayerName ?? '-'}';
    }
  }

  @override
  Widget build(BuildContext context) {
    // 교체 이벤트 여부에 따라 텍스트 내용 분기
    final isSubstitution = event.type == MatchEventType.substitution;
    // 홈팀이면 파란색, 어웨이팀이면 검정색으로 팀 구분
    final nameColor = event.isHomeTeam
        ? YouthFieldColor.blue700
        : YouthFieldColor.black800;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            child: Text(
              "${event.minute}'",
              style: YouthFieldTextStyle.textCount.copyWith(
                color: YouthFieldColor.black500,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          _buildIcon(),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              isSubstitution ? _label : event.playerName,
              style: YouthFieldTextStyle.textCount.copyWith(
                color: nameColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 출전 선수 라인업 섹션
///
/// 반응형 레이아웃:
/// - 너비 700px 이상: 홈/어웨이 팀 라인업을 좌우로 나란히 표시
/// - 너비 700px 미만: 홈팀 → 어웨이팀 순으로 세로 배치
class _LineupSection extends StatelessWidget {
  final String homeTeam;
  final String awayTeam;
  final List<PlayerRecord> homePlayers;
  final List<PlayerRecord> awayPlayers;

  const _LineupSection({
    required this.homeTeam,
    required this.awayTeam,
    required this.homePlayers,
    required this.awayPlayers,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '출전선수',
          style: YouthFieldTextStyle.body4.copyWith(
            color: YouthFieldColor.black800,
          ),
        ),
        const SizedBox(height: 10),
        // LayoutBuilder로 현재 너비에 따라 가로/세로 배치 분기
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 700) {
              // 와이드 화면: 홈·어웨이 나란히
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _TeamLineup(
                      teamName: homeTeam,
                      players: homePlayers,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _TeamLineup(
                      teamName: awayTeam,
                      players: awayPlayers,
                    ),
                  ),
                ],
              );
            }
            // 좁은 화면: 홈팀 위, 어웨이팀 아래
            return Column(
              children: [
                _TeamLineup(teamName: homeTeam, players: homePlayers),
                const SizedBox(height: 20),
                _TeamLineup(teamName: awayTeam, players: awayPlayers),
              ],
            );
          },
        ),
      ],
    );
  }
}

/// 한 팀의 선수 목록 테이블
///
/// 구성:
/// - 팀명 헤더
/// - 헤더 행: 배번·포지션·선수이름·득점·도움·경고·퇴장 (blue50 배경)
/// - 데이터 행: 각 선수 기록
class _TeamLineup extends StatelessWidget {
  final String teamName;
  final List<PlayerRecord> players;

  const _TeamLineup({required this.teamName, required this.players});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            teamName,
            textAlign: TextAlign.center,
            style: YouthFieldTextStyle.body4.copyWith(
              color: YouthFieldColor.black800,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: YouthFieldColor.blue50,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: const [
                    _HeaderCell('배번', flex: 1),
                    _HeaderCell('포지션', flex: 2),
                    _HeaderCell('선수이름', flex: 3),
                    _HeaderCell('득점', flex: 1),
                    _HeaderCell('도움', flex: 1),
                    _HeaderCell('경고', flex: 1),
                    _HeaderCell('퇴장', flex: 1),
                  ],
                ),
              ),
              ...players.map((p) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      _DataCell('${p.number}', flex: 1),
                      _DataCell(p.position, flex: 2),
                      _DataCell(p.name, flex: 3, bold: true),
                      _DataCell(p.goals > 0 ? '${p.goals}' : '-', flex: 1),
                      _DataCell(
                        p.assists > 0 ? '${p.assists}' : '-',
                        flex: 1,
                      ),
                      _DataCell(
                        p.yellowCards > 0 ? '${p.yellowCards}' : '-',
                        flex: 1,
                      ),
                      _DataCell(p.redCard ? '1' : '-', flex: 1),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}

/// 라인업 테이블 헤더 셀 (열 이름 표시)
///
/// [flex]로 열 너비 비율 지정
class _HeaderCell extends StatelessWidget {
  final String text;
  final int flex;

  const _HeaderCell(this.text, {required this.flex});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: YouthFieldTextStyle.placeholder.copyWith(
          color: YouthFieldColor.black500,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// 라인업 테이블 데이터 셀 (선수 기록 값 표시)
///
/// [bold]가 true이면 선수 이름 등 강조 항목에 w600 굵기 적용
class _DataCell extends StatelessWidget {
  final String text;
  final int flex;
  final bool bold;

  const _DataCell(this.text, {required this.flex, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: YouthFieldTextStyle.textCount.copyWith(
          color: YouthFieldColor.black800,
          fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }
}
