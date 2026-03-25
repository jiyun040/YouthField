import 'package:flutter/material.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';
import 'package:youthfield/features/main/data/mock_data.dart';
import 'package:youthfield/features/main/presentation/widgets/player_card.dart';
import 'package:youthfield/features/main/presentation/widgets/schedule_item.dart';

class HomeTab extends StatelessWidget {
  final VoidCallback onScheduleMoreTap;

  const HomeTab({super.key, required this.onScheduleMoreTap});

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
    final sortedSchedules =
        ([...mockSchedules]..sort(
              (a, b) =>
                  _parseStartDate(a.date).compareTo(_parseStartDate(b.date)),
            ))
            .take(5)
            .toList();

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
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = (constraints.maxWidth / 220).floor().clamp(
                2,
                6,
              );
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
          const SizedBox(height: 40),
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
          const SizedBox(height: 20),
          ...sortedSchedules.map(
            (s) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ScheduleItem(
                title: s.title,
                dateRange: s.date,
                venue: s.venue,
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
