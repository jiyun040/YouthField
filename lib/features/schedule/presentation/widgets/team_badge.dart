import 'package:flutter/material.dart';
import 'package:youthfield/core/constants/color.dart';

/// 실제 팀 로고가 생기면 Image.asset('assets/images/teams/$teamName.png')으로 교체하세요.
class TeamBadge extends StatelessWidget {
  final String teamName;

  const TeamBadge({super.key, required this.teamName});

  @override
  Widget build(BuildContext context) {
    return Container(width: 80, height: 80, color: YouthFieldColor.black50);
  }
}
