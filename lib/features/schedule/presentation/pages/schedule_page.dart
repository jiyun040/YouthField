import 'package:flutter/material.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';
import 'package:youthfield/features/schedule/data/repositories/schedule_repository_impl.dart';
import 'package:youthfield/features/schedule/domain/entities/schedule.dart';
import 'package:youthfield/features/schedule/presentation/pages/schedule_detail_page.dart';
import '../widgets/match_row.dart';
import '../widgets/schedule_list_item.dart';

/// 일정 탭의 최상위 라우팅 위젯
///
/// - [selectedIndex]가 null이면 전체 일정 목록([_ScheduleList]) 표시
/// - [selectedIndex]가 지정되면 해당 대회의 상세 페이지([ScheduleDetailPage]) 표시
class ScheduleBody extends StatelessWidget {
  /// 현재 선택된 일정 인덱스 (null이면 목록 뷰)
  final int? selectedIndex;

  /// 목록에서 항목을 선택했을 때 호출되는 콜백
  final ValueChanged<int> onSelect;

  const ScheduleBody({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    // 선택된 인덱스가 있으면 해당 대회의 상세 뷰로 전환
    if (selectedIndex != null) {
      return ScheduleDetailPage(event: scheduleMockEvents[selectedIndex!]);
    }
    // 선택된 항목이 없으면 전체 일정 목록 표시
    return _ScheduleList(onSelect: onSelect);
  }
}

/// 전체 대회·리그 목록을 표시하는 위젯
///
/// [scheduleMockEvents]를 순회하며 [ScheduleListItem]을 렌더링
class _ScheduleList extends StatelessWidget {
  /// 항목 탭 시 호출되는 콜백 (인덱스 전달)
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
