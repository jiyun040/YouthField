import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';
import 'package:youthfield/features/schedule/domain/entities/schedule.dart';
import 'package:youthfield/features/schedule/presentation/widgets/team_badge.dart';

class MatchDetailPage extends StatelessWidget {
  final ScheduleMatch match;
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
            _MatchDetailHeader(eventTitle: eventTitle),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _ScoreCard(match: match),
                    if (match.events.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _EventsSection(events: match.events),
                    ],
                    if (match.homePlayers.isNotEmpty ||
                        match.awayPlayers.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _LineupSection(
                        homeTeam: match.homeTeam,
                        awayTeam: match.awayTeam,
                        homeTeamLogoUrl: match.homeTeamLogoUrl,
                        awayTeamLogoUrl: match.awayTeamLogoUrl,
                        homePlayers: match.homePlayers,
                        awayPlayers: match.awayPlayers,
                      ),
                    ],
                    if (match.events.isEmpty &&
                        match.homePlayers.isEmpty &&
                        match.awayPlayers.isEmpty) ...[
                      const SizedBox(height: 24),
                      const _DetailUnavailableNotice(),
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

class _DetailUnavailableNotice extends StatelessWidget {
  const _DetailUnavailableNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: YouthFieldColor.blue50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '공개 일정에서는 점수와 팀 정보까지만 제공되고, 선발/교체/경고 같은 세부 기록은 JoinKFA 로그인 권한이 필요한 경기에서는 표시되지 않을 수 있습니다.',
        style: YouthFieldTextStyle.placeholder.copyWith(
          color: YouthFieldColor.black500,
        ),
      ),
    );
  }
}

class _MatchDetailHeader extends StatelessWidget {
  final String eventTitle;

  const _MatchDetailHeader({required this.eventTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      color: YouthFieldColor.background,
      child: Stack(
        children: [
          Positioned(
            left: 8,
            top: 0,
            bottom: 0,
            child: Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(
                  Symbols.arrow_back_ios,
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

class _ScoreCard extends StatelessWidget {
  final ScheduleMatch match;

  const _ScoreCard({required this.match});

  @override
  Widget build(BuildContext context) {
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
                child: Column(
                  children: [
                    TeamBadge(
                      teamName: match.homeTeam,
                      logoUrl: match.homeTeamLogoUrl,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      match.homeTeam,
                      textAlign: TextAlign.center,
                      style: YouthFieldTextStyle.body4.copyWith(
                        color: YouthFieldColor.blue700,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
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
                child: Column(
                  children: [
                    TeamBadge(
                      teamName: match.awayTeam,
                      logoUrl: match.awayTeamLogoUrl,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      match.awayTeam,
                      textAlign: TextAlign.center,
                      style: YouthFieldTextStyle.body4.copyWith(
                        color: YouthFieldColor.black800,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          Text(
            '${match.date}  ${match.time}  |  ${match.venue}',
            textAlign: TextAlign.center,
            style: YouthFieldTextStyle.placeholder.copyWith(
              color: YouthFieldColor.black500,
            ),
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
            const SizedBox(height: 4),
            Text(
              '경기 결과 집계 전입니다.',
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

class _EventsSection extends StatelessWidget {
  final List<MatchEvent> events;

  const _EventsSection({required this.events});

  @override
  Widget build(BuildContext context) {
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

class _EventRow extends StatelessWidget {
  final MatchEvent event;

  const _EventRow({required this.event});

  Widget _buildIcon() {
    switch (event.type) {
      case MatchEventType.goal:
        return const Icon(
          Symbols.sports_soccer,
          color: YouthFieldColor.blue700,
          size: 20,
        );
      case MatchEventType.yellowCard:
        return Container(
          width: 14,
          height: 18,
          decoration: BoxDecoration(
            color: const Color(0xFFFFC107),
            borderRadius: BorderRadius.circular(2),
          ),
        );
      case MatchEventType.redCard:
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
    final isSubstitution = event.type == MatchEventType.substitution;
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

class _LineupSection extends StatelessWidget {
  final String homeTeam;
  final String awayTeam;
  final String? homeTeamLogoUrl;
  final String? awayTeamLogoUrl;
  final List<PlayerRecord> homePlayers;
  final List<PlayerRecord> awayPlayers;

  const _LineupSection({
    required this.homeTeam,
    required this.awayTeam,
    this.homeTeamLogoUrl,
    this.awayTeamLogoUrl,
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
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 700) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _TeamLineup(
                      teamName: homeTeam,
                      logoUrl: homeTeamLogoUrl,
                      players: homePlayers,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _TeamLineup(
                      teamName: awayTeam,
                      logoUrl: awayTeamLogoUrl,
                      players: awayPlayers,
                    ),
                  ),
                ],
              );
            }
            return Column(
              children: [
                _TeamLineup(
                  teamName: homeTeam,
                  logoUrl: homeTeamLogoUrl,
                  players: homePlayers,
                ),
                const SizedBox(height: 20),
                _TeamLineup(
                  teamName: awayTeam,
                  logoUrl: awayTeamLogoUrl,
                  players: awayPlayers,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _TeamLineup extends StatelessWidget {
  final String teamName;
  final String? logoUrl;
  final List<PlayerRecord> players;

  const _TeamLineup({
    required this.teamName,
    this.logoUrl,
    required this.players,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TeamBadge(teamName: teamName, logoUrl: logoUrl),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  teamName,
                  textAlign: TextAlign.center,
                  style: YouthFieldTextStyle.body4.copyWith(
                    color: YouthFieldColor.black800,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (players.isEmpty)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: YouthFieldColor.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: YouthFieldColor.black50),
            ),
            child: Text(
              '등록된 선수 기록이 없습니다.',
              textAlign: TextAlign.center,
              style: YouthFieldTextStyle.placeholder.copyWith(
                color: YouthFieldColor.black500,
              ),
            ),
          ),
        if (players.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: YouthFieldColor.blue50,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
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
