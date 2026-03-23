import 'package:flutter/material.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';
import 'package:youthfield/features/schedule/domain/entities/schedule.dart';
import 'package:youthfield/features/schedule/presentation/widgets/match_row.dart';

class ScheduleDetailPage extends StatelessWidget {
  final ScheduleEvent event;

  const ScheduleDetailPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final grouped = <int, List<ScheduleMatch>>{};
    for (final m in event.matches) {
      (grouped[m.month] ??= []).add(m);
    }
    final months = grouped.keys.toList()..sort();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.title,
              style: YouthFieldTextStyle.body3.copyWith(
                color: YouthFieldColor.black800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              event.dateRange,
              style: YouthFieldTextStyle.textCount.copyWith(
                color: YouthFieldColor.black500,
              ),
            ),
            Text(
              event.venue,
              style: YouthFieldTextStyle.textCount.copyWith(
                color: YouthFieldColor.black500,
              ),
            ),
            const SizedBox(height: 24),
            for (final month in months) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: YouthFieldColor.blue700,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  '$month월',
                  style: YouthFieldTextStyle.smallButton.copyWith(
                    color: YouthFieldColor.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              for (final match in grouped[month]!)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: MatchRow(match: match),
                ),
              const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }
}
