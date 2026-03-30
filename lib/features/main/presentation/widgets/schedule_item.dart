import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';

class ScheduleItem extends StatelessWidget {
  final String title;
  final String dateRange;
  final String venue;
  final VoidCallback? onTap;

  const ScheduleItem({
    super.key,
    required this.title,
    required this.dateRange,
    required this.venue,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: YouthFieldColor.blue300.withValues(alpha: 0.3),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: YouthFieldColor.blue50,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: YouthFieldTextStyle.body4.copyWith(
                      color: YouthFieldColor.black800,
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$dateRange  |  $venue',
                    style: YouthFieldTextStyle.placeholder.copyWith(
                      color: YouthFieldColor.black500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Symbols.arrow_forward_ios,
              color: YouthFieldColor.black500,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
