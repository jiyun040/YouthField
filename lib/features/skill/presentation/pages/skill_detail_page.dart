import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';
import 'package:youthfield/core/widgets/yf_title_bar.dart';

class SkillDetailPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<String> steps;
  final String description;
  final String? youtubeUrl;

  const SkillDetailPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.steps,
    required this.description,
    this.youtubeUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YouthFieldColor.white,
      appBar: YFTitleBar(
        title: '스킬',
        actions: youtubeUrl != null
            ? [
                IconButton(
                  icon: const Icon(
                    Symbols.play_circle,
                    color: Colors.red,
                    size: 28,
                  ),
                  onPressed: () {
                    // TODO: YouTube 링크 열기
                  },
                ),
              ]
            : [],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: YouthFieldTextStyle.body3.copyWith(
                      color: YouthFieldColor.black800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: YouthFieldTextStyle.textCount.copyWith(
                      color: YouthFieldColor.black500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(color: YouthFieldColor.black50),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 8,
                    children: steps
                        .map(
                          (s) => Chip(
                            label: Text(
                              s,
                              style: YouthFieldTextStyle.smallButton.copyWith(
                                color: YouthFieldColor.white,
                              ),
                            ),
                            backgroundColor: YouthFieldColor.blue300,
                            side: BorderSide.none,
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    description,
                    style: YouthFieldTextStyle.textCount.copyWith(
                      color: YouthFieldColor.black800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
