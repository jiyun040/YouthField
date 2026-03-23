import 'package:flutter/material.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';
import 'package:youthfield/features/schedule/domain/entities/schedule.dart';
import 'package:youthfield/features/schedule/presentation/pages/match_detail_page.dart';
import 'package:youthfield/features/schedule/presentation/widgets/match_row.dart';

class ScheduleDetailPage extends StatefulWidget {
  final ScheduleEvent event;

  const ScheduleDetailPage({super.key, required this.event});

  @override
  State<ScheduleDetailPage> createState() => _ScheduleDetailPageState();
}

class _ScheduleDetailPageState extends State<ScheduleDetailPage> {
  late int _selectedMonth;
  late Map<int, List<ScheduleMatch>> _grouped;
  late List<int> _months;

  @override
  void initState() {
    super.initState();
    _grouped = {};
    for (final m in widget.event.matches) {
      (_grouped[m.month] ??= []).add(m);
    }
    _months = _grouped.keys.toList()..sort();
    _selectedMonth = _months.isNotEmpty ? _months.first : 0;
  }

  @override
  Widget build(BuildContext context) {
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

// ── 월 선택 드롭다운 ────────────────────────────────────────────────────────────
class _MonthDropdown extends StatelessWidget {
  final List<int> months;
  final int selectedMonth;
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
