import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';
import 'package:youthfield/features/skill/presentation/pages/skill_page.dart';
import 'package:youthfield/features/skill/presentation/widgets/skill_card.dart';

class SkillTab extends StatefulWidget {
  final ValueChanged<bool>? onSkillSelected;

  const SkillTab({super.key, this.onSkillSelected});

  @override
  State<SkillTab> createState() => SkillTabState();
}

class SkillTabState extends State<SkillTab> {
  int? _selectedIndex;
  int _stepIndex = 0;
  String _searchQuery = '';
  final _searchController = TextEditingController();

  bool get hasSelection => _selectedIndex != null;

  bool handleBack() {
    if (_selectedIndex != null) {
      setState(() {
        _selectedIndex = null;
        _stepIndex = 0;
        _searchQuery = '';
        _searchController.clear();
      });
      widget.onSkillSelected?.call(false);
      return true;
    }
    return false;
  }

  void _select(int index) {
    setState(() {
      _selectedIndex = index;
      _stepIndex = 0;
    });
    widget.onSkillSelected?.call(true);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          child: Container(
            decoration: BoxDecoration(
              color: YouthFieldColor.blue50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() {
                _searchQuery = val;
                _selectedIndex = null;
                widget.onSkillSelected?.call(false);
              }),
              decoration: InputDecoration(
                hintText: '배우고 싶은 스킬을 검색하세요.',
                hintStyle: YouthFieldTextStyle.placeholder.copyWith(
                  color: YouthFieldColor.black500,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        _buildBody(),
      ],
    );
  }

  Widget _buildBody() {
    if (_selectedIndex != null) {
      return _buildDetail(skillMockData[_selectedIndex!]);
    }
    final query = _searchQuery.trim().toLowerCase();
    if (query.isNotEmpty) {
      final results = <MapEntry<int, SkillData>>[];
      for (var i = 0; i < skillMockData.length; i++) {
        final s = skillMockData[i];
        if (s.title.toLowerCase().contains(query) ||
            s.subtitle.toLowerCase().contains(query)) {
          results.add(MapEntry(i, s));
        }
      }
      return _buildSearchResults(results);
    }
    return _buildGrid();
  }

  Widget _buildGrid() {
    const double spacing = 12;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cols = (constraints.maxWidth / 240).floor().clamp(2, 4);
          final cardWidth =
              (constraints.maxWidth - spacing * (cols - 1)) / cols;
          final cardHeight = cardWidth * 9 / 16;
          return Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: List.generate(skillMockData.length, (i) {
              final s = skillMockData[i];
              return SizedBox(
                width: cardWidth,
                height: cardHeight,
                child: SkillCard(
                  title: s.title,
                  subtitle: s.subtitle,
                  onTap: () => _select(i),
                ),
              );
            }),
          );
        },
      ),
    );
  }

  Widget _buildSearchResults(List<MapEntry<int, SkillData>> results) {
    if (results.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 60),
        child: Center(child: Text('검색 결과가 없습니다.')),
      );
    }
    return Column(
      children: results.map((entry) {
        final s = entry.value;
        return InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: YouthFieldColor.blue50,
          onTap: () {
            setState(() {
              _searchQuery = '';
              _searchController.clear();
            });
            _select(entry.key);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.title,
                        style: YouthFieldTextStyle.body4.copyWith(
                          color: YouthFieldColor.black800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        s.subtitle,
                        style: YouthFieldTextStyle.placeholder.copyWith(
                          color: YouthFieldColor.black500,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Symbols.chevron_right,
                  color: YouthFieldColor.black500,
                  size: 20,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDetail(SkillData s) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.title,
                      style: YouthFieldTextStyle.body3.copyWith(
                        color: YouthFieldColor.black800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      s.subtitle,
                      style: YouthFieldTextStyle.textCount.copyWith(
                        color: YouthFieldColor.black500,
                      ),
                    ),
                  ],
                ),
              ),
              if (s.youtubeUrl != null)
                GestureDetector(
                  onTap: () async {
                    final url = Uri.tryParse(s.youtubeUrl!);
                    if (url != null && await canLaunchUrl(url)) {
                      await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                  child: SvgPicture.asset(
                    'assets/svg/youtube_logo.svg',
                    width: 32,
                    height: 32,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(color: YouthFieldColor.black50),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(s.steps.length, (i) {
              final isSelected = i == _stepIndex;
              return GestureDetector(
                onTap: () => setState(() => _stepIndex = i),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? YouthFieldColor.blue700
                        : YouthFieldColor.blue300,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    s.steps[i].title,
                    style: YouthFieldTextStyle.smallButton.copyWith(
                      color: YouthFieldColor.white,
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 20),
          Text(
            s.steps[_stepIndex].description,
            style: YouthFieldTextStyle.textCount.copyWith(
              color: YouthFieldColor.black800,
            ),
          ),
        ],
      ),
    );
  }
}
