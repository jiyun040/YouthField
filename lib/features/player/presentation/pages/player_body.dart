import 'package:flutter/material.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';
import 'package:youthfield/features/diary/presentation/pages/diary_page.dart';
import 'package:youthfield/features/main/presentation/widgets/player_card.dart';
import 'package:youthfield/features/mypage/domain/entities/player_stats.dart';
import 'package:youthfield/features/player/data/clubs/all_clubs_data.dart';
import 'package:youthfield/features/player/domain/entities/player_info.dart';

const int kPlayerPageSize = 20;
const int kPlayerWindowSize = 5;

const _spacing10 = SizedBox(height: 10);
const _spacing40 = SizedBox(height: 40);

class PlayerBody extends StatefulWidget {
  final int? selectedIndex;
  final ValueChanged<int> onSelect;

  const PlayerBody({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  State<PlayerBody> createState() => _PlayerBodyState();
}

class _PlayerBodyState extends State<PlayerBody> {
  String _searchQuery = '';
  Set<String> _selectedPositions = {};
  Set<String> _selectedAgeGroups = {};
  int _currentPage = 0;
  int _windowStart = 0;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<({int originalIndex, PlayerInfo player})> get _filtered {
    final query = _searchQuery.toLowerCase();
    final indexed = allClubPlayers.asMap().entries.map((e) => (originalIndex: e.key, player: e.value)).toList();

    final result = indexed.where((item) {
      final p = item.player;

      if (query.isNotEmpty) {
        final matchesSearch = p.name.contains(query) || p.school.contains(query);
        if (!matchesSearch) return false;
      }

      if (_selectedPositions.isNotEmpty && !_selectedPositions.contains(p.position)) {
        return false;
      }

      if (_selectedAgeGroups.isNotEmpty && !_selectedAgeGroups.contains(p.ageGroup)) {
        return false;
      }

      return true;
    }).toList();

    result.sort((a, b) => a.player.name.compareTo(b.player.name));
    return result;
  }

  int get _totalPages {
    final n = _filtered.length;
    if (n == 0) return 1;
    return (n / kPlayerPageSize).ceil();
  }

  void _onPageTap(int page) {
    setState(() {
      _currentPage = page;
      _windowStart = (page ~/ kPlayerWindowSize) * kPlayerWindowSize;
    });
  }

  void _onPrevWindow() => setState(() => _windowStart -= kPlayerWindowSize);
  void _onNextWindow() => setState(() => _windowStart += kPlayerWindowSize);

  void _togglePosition(String pos) {
    setState(() {
      if (_selectedPositions.contains(pos)) {
        _selectedPositions = Set.from(_selectedPositions)..remove(pos);
      } else {
        _selectedPositions = Set.from(_selectedPositions)..add(pos);
      }
      _currentPage = 0;
      _windowStart = 0;
    });
  }

  void _toggleAgeGroup(String age) {
    setState(() {
      if (_selectedAgeGroups.contains(age)) {
        _selectedAgeGroups = Set.from(_selectedAgeGroups)..remove(age);
      } else {
        _selectedAgeGroups = Set.from(_selectedAgeGroups)..add(age);
      }
      _currentPage = 0;
      _windowStart = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedIndex != null) {
      return _PlayerDetailPage(player: allClubPlayers[widget.selectedIndex!]);
    }

    final filtered = _filtered;
    final totalPages = _totalPages;
    final start = _currentPage * kPlayerPageSize;
    final end = (start + kPlayerPageSize).clamp(0, filtered.length);
    final pageItems = filtered.sublist(start, end);

    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(40, 24, 40, 72),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: YouthFieldColor.blue50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: '선수 이름 또는 학교로 검색하세요.',
                      hintStyle: YouthFieldTextStyle.placeholder.copyWith(
                        color: YouthFieldColor.black500,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                    style: YouthFieldTextStyle.placeholder.copyWith(
                      color: YouthFieldColor.black800,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                        _currentPage = 0;
                        _windowStart = 0;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: ['GK', 'DF', 'MF', 'FW']
                      .map(
                        (pos) => _FilterChip(
                          label: pos,
                          selected: _selectedPositions.contains(pos),
                          onToggle: () => _togglePosition(pos),
                        ),
                      )
                      .toList(),
                ),
                _spacing10,
                Row(
                  children: ['U-12', 'U-15', 'U-18']
                      .map(
                        (age) => _FilterChip(
                          label: age,
                          selected: _selectedAgeGroups.contains(age),
                          onToggle: () => _toggleAgeGroup(age),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 20),
                if (pageItems.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 60),
                      child: Text(
                        '검색 결과가 없습니다.',
                        style: YouthFieldTextStyle.textCount.copyWith(
                          color: YouthFieldColor.black500,
                        ),
                      ),
                    ),
                  )
                else
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final crossAxisCount =
                          (constraints.maxWidth / 220).floor().clamp(2, 6);
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 3 / 4,
                        ),
                        itemCount: pageItems.length,
                        itemBuilder: (_, i) {
                          final item = pageItems[i];
                          final p = item.player;
                          return MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () => widget.onSelect(item.originalIndex),
                              child: PlayerCard(
                                name: p.name,
                                school: p.school,
                                location: p.location,
                                position: p.position,
                                ageGroup: p.ageGroup,
                                number: p.number,
                                imageUrl: p.imageUrl,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
        if (totalPages > 1)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: DiaryPaginationBar(
              currentPage: _currentPage,
              totalPages: totalPages,
              windowStart: _windowStart,
              onPageTap: _onPageTap,
              onPrevWindow: _onPrevWindow,
              onNextWindow: _onNextWindow,
            ),
          ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onToggle;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onToggle,
        child: Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: selected ? YouthFieldColor.blue700 : YouthFieldColor.blue50,
            border: selected
                ? null
                : Border.all(color: YouthFieldColor.black50),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            label,
            style: YouthFieldTextStyle.smallButton.copyWith(
              color: selected ? YouthFieldColor.white : YouthFieldColor.black800,
            ),
          ),
        ),
      ),
    );
  }
}

class _PlayerDetailPage extends StatelessWidget {
  final PlayerInfo player;

  const _PlayerDetailPage({required this.player});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _PlayerPhoto(imageUrl: player.imageUrl),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            player.name,
                            style: YouthFieldTextStyle.body3,
                          ),
                          const SizedBox(width: 10),
                          _PositionBadge(player.position),
                        ],
                      ),
                      _spacing10,
                      Text(
                        player.school,
                        style: YouthFieldTextStyle.textCount.copyWith(
                          color: YouthFieldColor.black500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        player.birthdate,
                        style: YouthFieldTextStyle.textCount.copyWith(
                          color: YouthFieldColor.black500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            _spacing40,
            _StatsTable(title: '통산기록', stats: player.seasonStats),
            _spacing40,
            _StatsTable(title: '국대기록', stats: player.nationalStats),
            _spacing40,
          ],
        ),
      ),
    );
  }
}

class _PlayerPhoto extends StatelessWidget {
  final String? imageUrl;

  const _PlayerPhoto({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 320,
        height: 360,
        child: imageUrl != null
            ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _placeholder(),
              )
            : _placeholder(),
      ),
    );
  }

  Widget _placeholder() => Container(
        color: YouthFieldColor.blue50,
        child: const Center(
          child: Icon(Icons.person, size: 80, color: YouthFieldColor.black300),
        ),
      );
}

class _PositionBadge extends StatelessWidget {
  final String position;

  const _PositionBadge(this.position);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: YouthFieldColor.blue700,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        position,
        style: YouthFieldTextStyle.smallButton.copyWith(
          color: YouthFieldColor.white,
        ),
      ),
    );
  }
}

class _StatsTable extends StatelessWidget {
  final String title;
  final PlayerStats stats;

  const _StatsTable({required this.title, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: YouthFieldTextStyle.body4),
        _spacing10,
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: YouthFieldColor.black50),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Table(
              border: TableBorder.symmetric(
                inside: const BorderSide(color: YouthFieldColor.black50),
              ),
              children: [
                const TableRow(
                  decoration: BoxDecoration(
                    color: YouthFieldColor.black50,
                  ),
                  children: [
                    _TableCell(text: '출장', isHeader: true),
                    _TableCell(text: '골', isHeader: true),
                    _TableCell(text: '도움', isHeader: true),
                    _TableCell(text: '경고', isHeader: true),
                    _TableCell(text: '퇴장', isHeader: true),
                  ],
                ),
                TableRow(
                  children: [
                    _TableCell(text: '${stats.appearances}'),
                    _TableCell(text: '${stats.goals}'),
                    _TableCell(text: '${stats.assists}'),
                    _TableCell(text: '${stats.yellowCards}'),
                    _TableCell(text: '${stats.redCards}'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TableCell extends StatelessWidget {
  final String text;
  final bool isHeader;

  const _TableCell({required this.text, this.isHeader = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Text(
          text,
          style: isHeader
              ? YouthFieldTextStyle.smallButton
              : YouthFieldTextStyle.textCount,
        ),
      ),
    );
  }
}
