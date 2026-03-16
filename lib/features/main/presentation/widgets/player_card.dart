import 'package:flutter/material.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';

class PlayerCard extends StatelessWidget {
  final String name;
  final String school;
  final String location;
  final String position;
  final String ageGroup;
  final int number;
  final String? imageUrl;

  const PlayerCard({
    super.key,
    required this.name,
    required this.school,
    required this.location,
    required this.position,
    required this.ageGroup,
    required this.number,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 배경 이미지 / 플레이스홀더
            if (imageUrl != null)
              Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _placeholder(),
              )
            else
              _placeholder(),

            // 포지션 뱃지 (좌상단)
            Positioned(
              top: 10,
              left: 10,
              child: _Badge(
                label: position,
                color: Colors.white,
                textColor: YouthFieldColor.black800,
              ),
            ),

            // 연령대 뱃지 (우상단)
            Positioned(
              top: 10,
              right: 10,
              child: _Badge(
                label: ageGroup,
                color: YouthFieldColor.blue800,
                textColor: YouthFieldColor.white,
              ),
            ),

            // 등번호
            Center(
              child: Text(
                '$number',
                style: const TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  shadows: [Shadow(blurRadius: 8, color: Colors.black45)],
                ),
              ),
            ),

            // 하단 정보 오버레이
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Color(0xDD000000), Colors.transparent],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$name ($school)',
                      style: YouthFieldTextStyle.smallButton.copyWith(
                        color: YouthFieldColor.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: YouthFieldColor.white,
                          size: 12,
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            location,
                            style: YouthFieldTextStyle.smallButton.copyWith(
                              color: YouthFieldColor.white,
                              fontWeight: FontWeight.w400,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() => Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFB71C1C), Color(0xFF7F0000)],
      ),
    ),
  );
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;

  const _Badge({
    required this.label,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: YouthFieldTextStyle.smallButton.copyWith(color: textColor),
      ),
    );
  }
}
