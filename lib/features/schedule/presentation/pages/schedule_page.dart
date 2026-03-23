import 'package:flutter/material.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';
import 'package:youthfield/features/schedule/data/repositories/schedule_repository_impl.dart';
import 'package:youthfield/features/schedule/domain/entities/schedule.dart';
import 'package:youthfield/features/schedule/presentation/pages/schedule_detail_page.dart';
import '../widgets/match_row.dart';
import '../widgets/schedule_list_item.dart';

class ScheduleBody extends StatelessWidget {
  final int? selectedIndex;
  final ValueChanged<int> onSelect;

  const ScheduleBody({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedIndex != null) {
      return ScheduleDetailPage(event: scheduleMockEvents[selectedIndex!]);
    }
    return _ScheduleList(onSelect: onSelect);
  }
}

class _ScheduleList extends StatelessWidget {
  final ValueChanged<int> onSelect;

  const _ScheduleList({required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: List.generate(scheduleMockEvents.length, (i) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ScheduleListItem(
              event: scheduleMockEvents[i],
              onTap: () => onSelect(i),
            ),
          );
        }),
      ),
    );
  }
}
