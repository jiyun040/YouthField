import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';
import 'package:youthfield/features/mypage/domain/entities/user_profile.dart';

class MypageProfileHeader extends StatelessWidget {
  static const spacing4 = SizedBox(height: 4);

  final UserProfile profile;

  const MypageProfileHeader({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _ProfilePhoto(
          imageBytes: profile.profileImageBytes,
          imageUrl: profile.profileImageUrl,
        ),
        const SizedBox(width: 20),
        Expanded(child: _buildProfileInfo()),
      ],
    );
  }

  Widget _buildProfileInfo() {
    return switch (profile) {
      PlayerProfile p => _buildPlayerInfo(p),
      StaffProfile s => _buildStaffInfo(s),
      GeneralProfile g => _buildGeneralInfo(g),
    };
  }

  Widget _buildPlayerInfo(PlayerProfile p) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(p.name, style: YouthFieldTextStyle.body3),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: YouthFieldColor.blue700,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                p.position,
                style: YouthFieldTextStyle.smallButton.copyWith(
                  color: YouthFieldColor.white,
                ),
              ),
            ),
          ],
        ),
        spacing4,
        Text(
          p.school,
          style: YouthFieldTextStyle.textCount.copyWith(
            color: YouthFieldColor.black500,
          ),
        ),
        spacing4,
        Text(
          DateFormat('yyyy.MM.dd').format(p.birthDate),
          style: YouthFieldTextStyle.textCount.copyWith(
            color: YouthFieldColor.black500,
          ),
        ),
      ],
    );
  }

  Widget _buildStaffInfo(StaffProfile s) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(s.name, style: YouthFieldTextStyle.body3),
        spacing4,
        Text(
          s.teamRole,
          style: YouthFieldTextStyle.textCount.copyWith(
            color: YouthFieldColor.black500,
          ),
        ),
      ],
    );
  }

  Widget _buildGeneralInfo(GeneralProfile g) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Text(g.name, style: YouthFieldTextStyle.body3)],
    );
  }
}

class _ProfilePhoto extends StatelessWidget {
  final Uint8List? imageBytes;
  final String? imageUrl;

  const _ProfilePhoto({this.imageBytes, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    ImageProvider? provider;
    if (imageBytes != null) {
      provider = MemoryImage(imageBytes!);
    } else if (imageUrl != null) {
      provider = NetworkImage(imageUrl!);
    }

    return Container(
      width: 320,
      height: 360,
      decoration: BoxDecoration(
        color: YouthFieldColor.blue50,
        borderRadius: BorderRadius.circular(8),
        image: provider != null
            ? DecorationImage(image: provider, fit: BoxFit.cover)
            : null,
      ),
      child: provider == null
          ? const Center(
              child: Icon(
                Symbols.person,
                size: 80,
                color: YouthFieldColor.black300,
              ),
            )
          : null,
    );
  }
}
