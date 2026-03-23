import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';
import 'package:youthfield/features/schedule/domain/entities/schedule.dart';

/// 일정 목록에서 대회·리그 하나를 표시하는 카드형 아이템
///
/// - 대회명(굵게) + 기간·장소(서브텍스트) + 우측 chevron 아이콘
/// - 탭 시 [onTap] 콜백 호출 → [ScheduleDetailPage]로 전환
/// - hover 시 연한 파란색(blue300 30%) 오버레이 표시
class ScheduleListItem extends StatelessWidget {
  /// 표시할 대회·리그 데이터
  final ScheduleEvent event;

  /// 카드 탭 시 호출되는 콜백
  final VoidCallback onTap;

  const ScheduleListItem({super.key, required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: YouthFieldColor.blue300.withOpacity(0.3),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: YouthFieldColor.blue50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 대회명
                  Text(
                    event.title,
                    style: YouthFieldTextStyle.body4.copyWith(
                      color: YouthFieldColor.black800,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // 기간 | 장소
                  Text(
                    '${event.dateRange}  |  ${event.venue}',
                    style: YouthFieldTextStyle.placeholder.copyWith(
                      color: YouthFieldColor.black500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // 상세 진입 유도 화살표
            const Icon(
              Symbols.chevron_right,
              color: YouthFieldColor.black500,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
