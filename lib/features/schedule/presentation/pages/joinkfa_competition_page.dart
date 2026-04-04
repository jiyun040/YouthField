import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';
import 'package:youthfield/features/schedule/data/models/joinkfa_models.dart';
import 'package:youthfield/features/schedule/domain/entities/schedule.dart';
import 'package:youthfield/features/schedule/presentation/pages/match_detail_page.dart';
import 'package:youthfield/features/schedule/presentation/providers/schedule_provider.dart';
import 'package:youthfield/features/schedule/presentation/widgets/match_row.dart';

class JoinkfaCompetitionPage extends ConsumerStatefulWidget {
  final JoinKfaCompetition competition;

  const JoinkfaCompetitionPage({super.key, required this.competition});

  @override
  ConsumerState<JoinkfaCompetitionPage> createState() =>
      _JoinkfaCompetitionPageState();
}

class _JoinkfaCompetitionPageState
    extends ConsumerState<JoinkfaCompetitionPage> {
  late String _selectedYearMonth;

  @override
  void initState() {
    super.initState();
    _selectedYearMonth = DateFormat('yyyyMM').format(DateTime.now());
  }

  List<String> _buildMonthOptions() {
    final now = DateTime.now();
    final months = <String>[];
    for (int i = -2; i <= 6; i++) {
      final d = DateTime(now.year, now.month + i);
      months.add(DateFormat('yyyyMM').format(d));
    }
    return months;
  }

  String _formatYearMonth(String ym) {
    if (ym.length < 6) return ym;
    return '${ym.substring(0, 4)}년 ${ym.substring(4, 6)}월';
  }

  @override
  Widget build(BuildContext context) {
    final key = (widget.competition.idx, _selectedYearMonth);
    final matchesAsync = ref.watch(competitionMatchesProvider(key));

    return Scaffold(
      backgroundColor: YouthFieldColor.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _Header(title: widget.competition.title),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.competition.title,
                      style: YouthFieldTextStyle.body3.copyWith(
                        color: YouthFieldColor.black800,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.competition.dateRange,
                      style: YouthFieldTextStyle.textCount.copyWith(
                        color: YouthFieldColor.black500,
                      ),
                    ),
                    if (widget.competition.areaName != null &&
                        widget.competition.areaName!.isNotEmpty)
                      Text(
                        widget.competition.areaName!,
                        style: YouthFieldTextStyle.textCount.copyWith(
                          color: YouthFieldColor.black500,
                        ),
                      ),
                    const SizedBox(height: 20),
                    _MonthSelector(
                      months: _buildMonthOptions(),
                      selected: _selectedYearMonth,
                      formatLabel: _formatYearMonth,
                      onChanged: (ym) =>
                          setState(() => _selectedYearMonth = ym),
                    ),
                    const SizedBox(height: 20),
                    matchesAsync.when(
                      loading: () => const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: CircularProgressIndicator(
                              color: YouthFieldColor.blue700),
                        ),
                      ),
                      error: (_, __) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: Text(
                            '경기 일정을 불러오지 못했습니다.',
                            style: YouthFieldTextStyle.body4.copyWith(
                              color: YouthFieldColor.black500,
                            ),
                          ),
                        ),
                      ),
                      data: (matches) {
                        if (matches.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: Center(
                              child: Text(
                                '해당 월에 등록된 경기가 없습니다.',
                                style: YouthFieldTextStyle.body4.copyWith(
                                  color: YouthFieldColor.black500,
                                ),
                              ),
                            ),
                          );
                        }
                        return Column(
                          children: matches.map((m) {
                            final entity = m.toEntity();
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: MatchRow(
                                match: entity,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => MatchDetailPage(
                                      match: entity,
                                      eventTitle: widget.competition.title,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String title;

  const _Header({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      color: YouthFieldColor.background,
      child: Stack(
        children: [
          Positioned(
            left: 8,
            top: 0,
            bottom: 0,
            child: Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(
                  Symbols.arrow_back_ios,
                  color: YouthFieldColor.blue700,
                  size: 32,
                ),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          Center(
            child: Text(
              title.length > 20 ? '${title.substring(0, 20)}…' : title,
              style: YouthFieldTextStyle.body4.copyWith(
                color: YouthFieldColor.black800,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthSelector extends StatelessWidget {
  final List<String> months;
  final String selected;
  final String Function(String) formatLabel;
  final ValueChanged<String> onChanged;

  const _MonthSelector({
    required this.months,
    required this.selected,
    required this.formatLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onChanged,
      color: YouthFieldColor.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      offset: const Offset(0, 40),
      itemBuilder: (_) => months
          .map(
            (m) => PopupMenuItem<String>(
              value: m,
              child: Center(
                child: Text(
                  formatLabel(m),
                  style: YouthFieldTextStyle.body4.copyWith(
                    color: m == selected
                        ? YouthFieldColor.blue700
                        : YouthFieldColor.black800,
                    fontWeight:
                        m == selected ? FontWeight.w700 : FontWeight.w400,
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
              formatLabel(selected),
              style: YouthFieldTextStyle.smallButton.copyWith(
                color: YouthFieldColor.white,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Symbols.expand_more,
              color: YouthFieldColor.white,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

