import 'package:flutter/material.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';
import 'package:youthfield/features/main/data/mock_data.dart';
import 'package:youthfield/features/main/presentation/widgets/player_card.dart';
import 'package:youthfield/features/main/presentation/widgets/schedule_item.dart';
import 'package:youthfield/features/schedule/data/repositories/schedule_repository_impl.dart';

class HomeTab extends StatelessWidget {
  final VoidCallback onScheduleMoreTap;
  final ValueChanged<int> onScheduleTap;

  static const spacing20 = SizedBox(height: 20);
  static const spacing40 = SizedBox(height: 40);

  const HomeTab({
    super.key,
    required this.onScheduleMoreTap,
    required this.onScheduleTap,
  });

  DateTime _parseStartDate(String dateRange) {
    final parts = dateRange.split(' ~ ').first.trim().split('.');
    return DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final indexed = scheduleMockEvents
        .asMap()
        .entries
        .toList()
      ..sort(
        (a, b) => _parseStartDate(
          a.value.dateRange,
        ).compareTo(_parseStartDate(b.value.dateRange)),
      );
    final top5 = indexed.take(5).toList();

    return Padding(
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
                itemCount: mockPlayers.length,
                itemBuilder: (_, i) {
                  final p = mockPlayers[i];
                  return PlayerCard(
                    name: p.name,
                    school: p.school,
                    location: p.location,
                    position: p.position,
                    ageGroup: p.age,
                    number: p.number,
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
                onTap: onScheduleMoreTap,
                child: Text('더보기', style: YouthFieldTextStyle.smallButton),
              ),
            ],
          ),
          spacing20,
          ...top5.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ScheduleItem(
                title: entry.value.title,
                dateRange: entry.value.dateRange,
                venue: entry.value.venue,
                onTap: () => onScheduleTap(entry.key),
              ),
            ),
          ),
          spacing40,
        ],
      ),
    );
  }
}
