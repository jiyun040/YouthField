import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';
import 'package:youthfield/features/schedule/data/models/kleague_models.dart';
import 'package:youthfield/features/schedule/domain/entities/schedule.dart';
import 'package:youthfield/features/schedule/presentation/pages/schedule_detail_page.dart';
import 'package:youthfield/features/schedule/presentation/providers/schedule_provider.dart';
import '../widgets/schedule_list_item.dart';

class ScheduleBody extends ConsumerStatefulWidget {
  const ScheduleBody({super.key});

  @override
  ConsumerState<ScheduleBody> createState() => _ScheduleBodyState();
}

class _ScheduleBodyState extends ConsumerState<ScheduleBody> {
  KleagueLeague? _selectedLeague;
  List<ScheduleMatch>? _selectedMatches;

  void _selectLeague(KleagueLeague league, List<ScheduleMatch> matches) {
    setState(() {
      _selectedLeague = league;
      _selectedMatches = matches;
    });
  }

  void _goBack() {
    setState(() {
      _selectedLeague = null;
      _selectedMatches = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedLeague != null) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _goBack,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Symbols.arrow_back_ios,
                      size: 16, color: YouthFieldColor.blue700),
                  const SizedBox(width: 4),
                  Text(
                    '리그 목록',
                    style: YouthFieldTextStyle.textCount.copyWith(
                      color: YouthFieldColor.blue700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ScheduleDetailPage(
              event: ScheduleEvent(
                title: _selectedLeague!.leagueName,
                dateRange: _selectedMatches!.isNotEmpty
                    ? '${_selectedMatches!.first.date} ~ ${_selectedMatches!.last.date}'
                    : '-',
                venue: _selectedMatches!.isNotEmpty
                    ? _selectedMatches!.first.venue
                    : '-',
                matches: _selectedMatches!,
              ),
            ),
          ],
        ),
      );
    }

    return _ScheduleList(onSelectLeague: _selectLeague);
  }
}

class _ScheduleList extends ConsumerWidget {
  final void Function(KleagueLeague, List<ScheduleMatch>) onSelectLeague;

  const _ScheduleList({required this.onSelectLeague});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(scheduleProvider);

    return async.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 60),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: YouthFieldColor.blue700),
              SizedBox(height: 16),
              Text('K리그 유스 일정을 불러오는 중...'),
            ],
          ),
        ),
      ),
      error: (_, __) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Symbols.wifi_off,
                  size: 48, color: YouthFieldColor.black300),
              const SizedBox(height: 12),
              Text(
                '일정을 불러오지 못했습니다.',
                style: YouthFieldTextStyle.body4
                    .copyWith(color: YouthFieldColor.black500),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => ref.invalidate(scheduleProvider),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 10),
                  decoration: BoxDecoration(
                    color: YouthFieldColor.blue700,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    '다시 시도',
                    style: YouthFieldTextStyle.smallButton
                        .copyWith(color: YouthFieldColor.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      data: (feed) {
        final result = feed.kleague;
        final leagues = result.leagues;
        if (leagues.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 60),
            child: Center(
              child: Text(
                '현재 등록된 경기 일정이 없습니다.',
                style: YouthFieldTextStyle.body4
                    .copyWith(color: YouthFieldColor.black500),
              ),
            ),
          );
        }

        final matchesByLeague = <int, List<ScheduleMatch>>{};
        for (final m in result.matches) {
          matchesByLeague
              .putIfAbsent(m.leagueId, () => [])
              .add(m.toEntity(emblemByTeam: feed.emblemByTeam));
        }

        for (final list in matchesByLeague.values) {
          list.sort((a, b) => a.date.compareTo(b.date));
        }

        final highSchool =
            leagues.where((l) => l.leagueName.contains('고등')).toList();
        final middleSchool =
            leagues.where((l) => l.leagueName.contains('중등')).toList();

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (highSchool.isNotEmpty) ...[
                _sectionLabel('고등 (U18)'),
                const SizedBox(height: 10),
                ..._leagueItems(highSchool, matchesByLeague),
                const SizedBox(height: 24),
              ],
              if (middleSchool.isNotEmpty) ...[
                _sectionLabel('중등 (U15)'),
                const SizedBox(height: 10),
                ..._leagueItems(middleSchool, matchesByLeague),
              ],
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: YouthFieldTextStyle.body4.copyWith(
        color: YouthFieldColor.blue700,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  List<Widget> _leagueItems(
    List<KleagueLeague> leagues,
    Map<int, List<ScheduleMatch>> matchesByLeague,
  ) {
    return leagues.map((league) {
      final matches = matchesByLeague[league.leagueId] ?? [];
      final dateRange = matches.isNotEmpty
          ? '${matches.first.date} ~ ${matches.last.date}'
          : '일정 없음';
      final venue = matches.isNotEmpty ? matches.first.venue : '-';

      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: ScheduleListItem(
          event: ScheduleEvent(
            title: league.leagueName,
            dateRange: dateRange,
            venue: venue,
            matches: matches,
          ),
          onTap: () => onSelectLeague(league, matches),
        ),
      );
    }).toList();
  }
}
