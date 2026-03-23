import 'package:flutter/material.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';
import 'package:youthfield/features/schedule/domain/entities/schedule.dart';
import 'team_badge.dart';

class MatchRow extends StatelessWidget {
  final ScheduleMatch match;

  const MatchRow({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: YouthFieldColor.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: YouthFieldColor.black300),
      ),
      child: Row(
        children: [
          TeamBadge(teamName: match.homeTeam),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Text(
              match.homeTeam,
              style: YouthFieldTextStyle.body4.copyWith(
                color: YouthFieldColor.black800,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          Expanded(
            flex: 4,
            child: Column(
              children: [
                Text(
                  '${match.date} ${match.venue} ${match.time}',
                  textAlign: TextAlign.center,
                  style: YouthFieldTextStyle.textCount.copyWith(
                    color: YouthFieldColor.black500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  match.score ?? '예정',
                  textAlign: TextAlign.center,
                  style: YouthFieldTextStyle.body4.copyWith(
                    color: match.score != null
                        ? YouthFieldColor.black800
                        : YouthFieldColor.black500,
                    fontWeight: match.score != null
                        ? FontWeight.w700
                        : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            flex: 3,
            child: Text(
              match.awayTeam,
              textAlign: TextAlign.right,
              style: YouthFieldTextStyle.body4.copyWith(
                color: YouthFieldColor.black800,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 10),
          TeamBadge(teamName: match.awayTeam),
        ],
      ),
    );
  }
}
