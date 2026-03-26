import 'package:flutter/material.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';
import 'package:youthfield/features/mypage/domain/entities/recent_player.dart';

class MypagePlayerCarousel extends StatelessWidget {
  final List<RecentPlayer> players;

  const MypagePlayerCarousel({super.key, required this.players});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('최근 본 선수', style: YouthFieldTextStyle.body4),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: players.map((p) => _PlayerMiniCard(player: p)).toList(),
          ),
        ),
      ],
    );
  }
}

class _PlayerMiniCard extends StatelessWidget {
  final RecentPlayer player;

  const _PlayerMiniCard({required this.player});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: YouthFieldColor.blue50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: Container(color: YouthFieldColor.blue300),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: YouthFieldColor.blue700,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    player.position,
                    style: YouthFieldTextStyle.placeholder.copyWith(
                      fontWeight: FontWeight.w700,
                      color: YouthFieldColor.white,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(player.name, style: YouthFieldTextStyle.smallButton),
                const SizedBox(height: 2),
                Text(
                  player.school,
                  style: YouthFieldTextStyle.placeholder.copyWith(
                    color: YouthFieldColor.black500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
