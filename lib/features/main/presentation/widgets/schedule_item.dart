import 'package:flutter/material.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';

class ScheduleItem extends StatelessWidget {
  final String title;
  final String dateRange;
  final String venue;

  const ScheduleItem({
    super.key,
    required this.title,
    required this.dateRange,
    required this.venue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: YouthFieldColor.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        '$title  |  $dateRange  |  $venue',
        style: YouthFieldTextStyle.textCount.copyWith(
          color: YouthFieldColor.black800,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }
}
