import 'package:flutter/material.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';
import 'package:youthfield/features/schedule/domain/entities/schedule.dart';
import 'package:youthfield/features/schedule/presentation/pages/match_detail_page.dart';
import 'package:youthfield/features/schedule/presentation/widgets/match_row.dart';

/// 특정 대회·리그의 경기 목록을 월별로 필터링해서 보여주는 상세 페이지
///
/// 상단에 대회 정보(제목·기간·장소)를 표시하고,
/// [_MonthDropdown]으로 월을 선택하면 해당 월의 경기만 렌더링
/// 각 경기 행([MatchRow]) 탭 시 [MatchDetailPage]로 이동
class ScheduleDetailPage extends StatefulWidget {
  /// 표시할 대회·리그 데이터
  final ScheduleEvent event;

  const ScheduleDetailPage({super.key, required this.event});

  @override
  State<ScheduleDetailPage> createState() => _ScheduleDetailPageState();
}

class _ScheduleDetailPageState extends State<ScheduleDetailPage> {
  /// 현재 선택된 월
  late int _selectedMonth;

  /// 월(int) → 해당 월의 경기 목록 맵
  late Map<int, List<ScheduleMatch>> _grouped;

  /// 정렬된 월 목록 (드롭다운 항목)
  late List<int> _months;

  @override
  void initState() {
    super.initState();
    // 경기 목록을 월 기준으로 그룹화
    _grouped = {};
    for (final m in widget.event.matches) {
      (_grouped[m.month] ??= []).add(m);
    }
    // 월을 오름차순 정렬
    _months = _grouped.keys.toList()..sort();
    // 초기 선택 월: 가장 빠른 월
    _selectedMonth = _months.isNotEmpty ? _months.first : 0;
  }

  @override
  Widget build(BuildContext context) {
    // 현재 선택된 월의 경기 목록
    final matches = _grouped[_selectedMonth] ?? [];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.event.title,
              style: YouthFieldTextStyle.body3.copyWith(
                color: YouthFieldColor.black800,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.event.dateRange,
              style: YouthFieldTextStyle.textCount.copyWith(
                color: YouthFieldColor.black500,
              ),
            ),
            Text(
              widget.event.venue,
              style: YouthFieldTextStyle.textCount.copyWith(
                color: YouthFieldColor.black500,
              ),
            ),
            const SizedBox(height: 24),
            _MonthDropdown(
              months: _months,
              selectedMonth: _selectedMonth,
              onChanged: (m) => setState(() => _selectedMonth = m),
            ),
            const SizedBox(height: 20),
            ...matches.map(
              (m) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: MatchRow(
                  match: m,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MatchDetailPage(
                        match: m,
                        eventTitle: widget.event.title,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 월 선택 드롭다운 위젯
///
/// pill 형태의 버튼을 탭하면 [PopupMenuButton]으로 전체 월 목록이 펼쳐짐
/// 현재 선택된 월은 파란색 bold, 나머지는 기본 스타일로 표시
class _MonthDropdown extends StatelessWidget {
  /// 드롭다운에 표시할 월 목록
  final List<int> months;

  /// 현재 선택된 월
  final int selectedMonth;

  /// 월을 선택했을 때 호출되는 콜백
  final ValueChanged<int> onChanged;

  const _MonthDropdown({
    required this.months,
    required this.selectedMonth,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      onSelected: onChanged,
      color: YouthFieldColor.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      offset: const Offset(0, 40),
      itemBuilder: (_) => months
          .map(
            (m) => PopupMenuItem<int>(
              value: m,
              child: Center(
                child: Text(
                  '$m월',
                  style: YouthFieldTextStyle.body4.copyWith(
                    color: m == selectedMonth
                        ? YouthFieldColor.blue700
                        : YouthFieldColor.black800,
                    fontWeight: m == selectedMonth
                        ? FontWeight.w700
                        : FontWeight.w400,
                  ),
                ),
              ),
            ),
          )
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: YouthFieldColor.blue700,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$selectedMonth월',
              style: YouthFieldTextStyle.smallButton.copyWith(
                color: YouthFieldColor.white,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.expand_more,
              color: YouthFieldColor.white,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
