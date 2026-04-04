import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';
import 'package:youthfield/features/main/presentation/widgets/player_card.dart';
import 'package:youthfield/features/mypage/domain/entities/recent_player.dart';
import 'package:youthfield/features/player/data/clubs/all_clubs_data.dart';
import 'package:youthfield/features/player/presentation/pages/player_detail_scaffold.dart';

class RecentPlayersPage extends StatelessWidget {
  final List<RecentPlayer> players;

  const RecentPlayersPage({super.key, required this.players});

  void _openDetail(BuildContext context, RecentPlayer p) {
    final info = allClubPlayers.firstWhere(
      (info) => info.name == p.name,
      orElse: () => allClubPlayers.first,
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PlayerDetailScaffold(player: info)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YouthFieldColor.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: players.isEmpty
                ? Center(
                    child: Text(
                      '아직 찾아본 선수가 없습니다.',
                      style: YouthFieldTextStyle.body4.copyWith(
                        color: YouthFieldColor.black300,
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 80, 24, 40),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final cols = (constraints.maxWidth / 220).floor().clamp(
                          2,
                          6,
                        );
                        const spacing = 12.0;
                        final cardWidth =
                            (constraints.maxWidth - spacing * (cols - 1)) /
                            cols;

                        return Wrap(
                          spacing: spacing,
                          runSpacing: spacing,
                          children: players.map((p) {
                            return SizedBox(
                              width: cardWidth,
                              child: AspectRatio(
                                aspectRatio: 3 / 4,
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: () => _openDetail(context, p),
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
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 72,
              color: YouthFieldColor.background,
              child: Stack(
                children: [
                  Center(
                    child: Text('찾아본 선수 목록', style: YouthFieldTextStyle.body3),
                  ),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
