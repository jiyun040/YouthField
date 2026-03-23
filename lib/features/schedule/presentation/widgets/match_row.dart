import 'package:flutter/material.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';
import 'package:youthfield/features/schedule/domain/entities/schedule.dart';
import 'team_badge.dart';

/// 일정 상세 페이지에서 개별 경기를 표시하는 행 위젯
///
/// 레이아웃: [홈팀 배지] [홈팀명] [날짜·장소·스코어] [어웨이팀명] [어웨이팀 배지]
/// - score가 있으면 굵은 검정 스코어, 없으면 회색 "예정" 텍스트 표시
/// - [onTap]이 지정되면 탭 시 해당 경기 상세([MatchDetailPage])로 이동
class MatchRow extends StatelessWidget {
  /// 표시할 경기 데이터
  final ScheduleMatch match;

  /// 행 탭 콜백 (null이면 탭 비활성)
  final VoidCallback? onTap;

  const MatchRow({super.key, required this.match, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: YouthFieldColor.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: YouthFieldColor.black300),
        ),
        child: Row(
          children: [
            // 홈팀 배지 (팀 로고 placeholder)
            TeamBadge(teamName: match.homeTeam),
            const SizedBox(width: 10),
            // 홈팀 이름 (좌측 정렬)
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
            // 중앙: 날짜·장소·시간 + 스코어(또는 "예정")
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
                      // 스코어 확정 시 검정/굵게, 미확정 시 회색/얇게
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
            // 어웨이팀 이름 (우측 정렬)
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
            // 어웨이팀 배지 (팀 로고 placeholder)
            TeamBadge(teamName: match.awayTeam),
          ],
        ),
      ), // Container
    ); // GestureDetector
  }
}
