import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';
import 'package:youthfield/features/player/domain/entities/player_info.dart';
import 'package:youthfield/features/player/presentation/pages/player_body.dart';

class PlayerDetailScaffold extends StatelessWidget {
  final PlayerInfo player;

  const PlayerDetailScaffold({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YouthFieldColor.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 72),
                  PlayerDetailView(player: player),
                ],
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
                    child: Text(player.name, style: YouthFieldTextStyle.body3),
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
