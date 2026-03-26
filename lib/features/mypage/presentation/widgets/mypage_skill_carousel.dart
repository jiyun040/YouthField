import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';
import 'package:youthfield/features/mypage/domain/entities/watched_skill.dart';
import 'package:youthfield/features/skill/presentation/widgets/skill_card.dart';

class MypageSkillCarousel extends StatefulWidget {
  final List<WatchedSkill> skills;

  const MypageSkillCarousel({super.key, required this.skills});

  @override
  State<MypageSkillCarousel> createState() => _MypageSkillCarouselState();
}

class _MypageSkillCarouselState extends State<MypageSkillCarousel> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  static const double _cardWidth = 260;
  static const double _cardHeight = _cardWidth * 9 / 16;
  static const double _cardSpacing = 12;
  static const double _scrollStep = _cardWidth + _cardSpacing;

  bool get _canScrollLeft =>
      _scrollController.hasClients && _scrollController.offset > 0;

  bool get _canScrollRight =>
      _scrollController.hasClients &&
      _scrollController.offset < _scrollController.position.maxScrollExtent;

  void _scrollLeft() {
    if (!_canScrollLeft) return;
    _scrollController.animateTo(
      (_scrollController.offset - _scrollStep).clamp(0.0, double.infinity),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollRight() {
    if (!_canScrollRight) return;
    _scrollController.animateTo(
      _scrollController.offset + _scrollStep,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('시청한 스킬', style: YouthFieldTextStyle.body4),
        const SizedBox(height: 10),
        Row(
          children: [
            _ArrowButton(icon: Symbols.chevron_left, onTap: _scrollLeft),
            const SizedBox(width: 4),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                child: Row(
                  children: widget.skills.map((skill) {
                    return Padding(
                      padding: const EdgeInsets.only(right: _cardSpacing),
                      child: SizedBox(
                        width: _cardWidth,
                        height: _cardHeight,
                        child: SkillCard(
                          title: skill.title,
                          subtitle: skill.subtitle,
                          onTap: () {},
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(width: 4),
            _ArrowButton(icon: Symbols.chevron_right, onTap: _scrollRight),
          ],
        ),
      ],
    );
  }
}

class _ArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ArrowButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Icon(icon, size: 28, color: YouthFieldColor.blue700),
      ),
    );
  }
}
