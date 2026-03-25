import 'package:flutter/material.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';

class YFTitleBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final VoidCallback? onBack;
  final List<Widget> actions;

  const YFTitleBar({
    super.key,
    required this.title,
    this.showBack = true,
    this.onBack,
    this.actions = const [],
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      color: YouthFieldColor.white,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 56),
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: YouthFieldTextStyle.body3.copyWith(
                color: YouthFieldColor.black800,
              ),
            ),
          ),

          if (showBack)
            Positioned(
              left: 0,
              child: IconButton(
                onPressed: onBack ?? () => Navigator.maybePop(context),
                icon: const Icon(
                  Icons.chevron_left,
                  color: YouthFieldColor.blue700,
                  size: 32,
                ),
              ),
            ),

          if (actions.isNotEmpty)
            Positioned(
              right: 0,
              child: Row(mainAxisSize: MainAxisSize.min, children: actions),
            ),
        ],
      ),
    );
  }
}
