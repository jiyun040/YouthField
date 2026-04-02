import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';
import 'package:youthfield/features/main/presentation/widgets/player_card.dart';
import 'package:youthfield/features/main/presentation/widgets/schedule_item.dart';
import 'package:youthfield/features/player/data/clubs/all_clubs_data.dart';
import 'package:youthfield/features/player/domain/entities/player_info.dart';
import 'package:youthfield/features/schedule/domain/entities/schedule.dart';
import 'package:youthfield/features/schedule/presentation/providers/schedule_provider.dart';

class HomeTab extends ConsumerStatefulWidget {
  final VoidCallback onScheduleMoreTap;
  final ValueChanged<String>? onPlayerTap;

  const HomeTab({
    super.key,
    required this.onScheduleMoreTap,
    this.onPlayerTap,
  });

  @override
  ConsumerState<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab> {
  static const spacing20 = SizedBox(height: 20);
  static const spacing40 = SizedBox(height: 40);

  late final List<PlayerInfo> _topPlayers;

  @override
  void initState() {
    super.initState();
    _topPlayers = _selectTopPlayers();
  }

  List<PlayerInfo> _selectTopPlayers() {
    final rng = Random();
    List<PlayerInfo> pick(String pos, int count) {
      final list = allClubPlayers.where((p) => p.position == pos).toList()
        ..shuffle(rng);
      return list.take(count).toList();
    }

    return [
      ...pick('GK', 2),
      ...pick('DF', 2),
      ...pick('MF', 3),
      ...pick('FW', 4),
    ];
  }

  List<ScheduleEvent> _top5(List<ScheduleEvent> events) {
    return events.take(5).toList();
  }

  @override
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(scheduleProvider).whenData((r) => r.toScheduleEvents());

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TOP PLAYERS',
            style: YouthFieldTextStyle.body3.copyWith(
              color: YouthFieldColor.black800,
            ),
          ),
          spacing20,
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount =
                  (constraints.maxWidth / 220).floor().clamp(2, 6);
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 3 / 4,
                ),
                itemCount: _topPlayers.length,
                itemBuilder: (_, i) {
                  final p = _topPlayers[i];
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => widget.onPlayerTap?.call(p.name),
                      child: PlayerCard(
                        name: p.name,
                        school: p.school,
                        location: p.location,
                        position: p.position,
                        ageGroup: p.ageGroup,
                        number: p.number,
                        imageUrl: p.imageUrl,
                      ),
                    ),
                  );
                },
              );
            },
          ),
          spacing40,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '경기 일정',
                style: YouthFieldTextStyle.body3.copyWith(
                  color: YouthFieldColor.black800,
                ),
              ),
              GestureDetector(
                onTap: widget.onScheduleMoreTap,
                child: Text('더보기', style: YouthFieldTextStyle.smallButton),
              ),
            ],
          ),
          spacing20,
          eventsAsync.when(
            loading: () => const SizedBox(
              height: 60,
              child: Center(
                child: CircularProgressIndicator(
                  color: YouthFieldColor.blue700,
                  strokeWidth: 2,
                ),
              ),
            ),
            error: (_, __) => Text(
              '일정을 불러오지 못했습니다.',
              style: YouthFieldTextStyle.placeholder.copyWith(
                color: YouthFieldColor.black300,
              ),
            ),
            data: (events) {
              final top5 = _top5(events);
              if (top5.isEmpty) {
                return Text(
                  '등록된 경기 일정이 없습니다.',
                  style: YouthFieldTextStyle.placeholder.copyWith(
                    color: YouthFieldColor.black300,
                  ),
                );
              }
              return Column(
                children: top5
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ScheduleItem(
                          title: e.title,
                          dateRange: e.dateRange,
                          venue: e.venue,
                          onTap: widget.onScheduleMoreTap,
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
          spacing40,
        ],
      ),
    );
  }
}
