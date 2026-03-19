import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';

class YFAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isLoggedIn;
  final VoidCallback onLogin;
  final VoidCallback onLogout;
  final VoidCallback? onLogoTap;

  const YFAppBar({
    super.key,
    required this.isLoggedIn,
    required this.onLogin,
    required this.onLogout,
    this.onLogoTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      color: YouthFieldColor.background,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        children: [
          GestureDetector(
            onTap:
                onLogoTap ??
                () => Navigator.popUntil(context, (route) => route.isFirst),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: SvgPicture.asset('assets/svg/logo.svg'),
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: onLogin,
            child: Text(
              '로그인',
              style: YouthFieldTextStyle.smallButton.copyWith(
                color: YouthFieldColor.black800,
              ),
            ),
          ),
          TextButton(
            onPressed: onLogout,
            child: Text(
              '로그아웃',
              style: YouthFieldTextStyle.smallButton.copyWith(
                color: YouthFieldColor.black800,
              ),
            ),
          ),
          const Icon(Icons.sports_soccer, color: YouthFieldColor.blue700),
        ],
      ),
    );
  }
}
