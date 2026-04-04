import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';

class YFAppBar extends StatelessWidget implements PreferredSizeWidget {
  static const double barHeight = 64;

  final bool isLoggedIn;
  final VoidCallback onLogin;
  final VoidCallback onLogout;
  final VoidCallback? onLogoTap;
  final VoidCallback? onProfileTap;
  final Uint8List? profileImageBytes;
  final String? profilePhotoUrl;

  const YFAppBar({
    super.key,
    required this.isLoggedIn,
    required this.onLogin,
    required this.onLogout,
    this.onLogoTap,
    this.onProfileTap,
    this.profileImageBytes,
    this.profilePhotoUrl,
  });

  @override
  Size get preferredSize => const Size.fromHeight(barHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: barHeight,
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
          GestureDetector(
            onTap: onProfileTap,
            child: MouseRegion(
              cursor: onProfileTap != null
                  ? SystemMouseCursors.click
                  : MouseCursor.defer,
              child: _buildProfileWidget(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileWidget() {
    if (isLoggedIn) {
      if (profileImageBytes != null) {
        return CircleAvatar(
          radius: 16,
          backgroundImage: MemoryImage(profileImageBytes!),
        );
      }
      if (profilePhotoUrl != null && profilePhotoUrl!.isNotEmpty) {
        return CircleAvatar(
          radius: 16,
          backgroundImage: NetworkImage(profilePhotoUrl!),
        );
      }
      return const CircleAvatar(
        radius: 16,
        backgroundColor: YouthFieldColor.blue50,
        child: Icon(Icons.person, size: 18, color: YouthFieldColor.blue700),
      );
    }
    return const Icon(Symbols.sports_soccer, color: YouthFieldColor.blue700);
  }
}
