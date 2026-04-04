import 'package:flutter/material.dart';
import 'package:youthfield/core/constants/color.dart';
import 'team_logo_asset.dart';

class TeamBadge extends StatelessWidget {
  final String teamName;
  final String? logoUrl;

  const TeamBadge({
    super.key,
    required this.teamName,
    this.logoUrl,
  });

  @override
  Widget build(BuildContext context) {
    final fallbackAssetPath = resolveTeamLogoAssetPath(teamName);

    return SizedBox(
      width: 56,
      height: 56,
      child: logoUrl != null && logoUrl!.isNotEmpty
          ? Image.network(
              logoUrl!,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => _assetOrFallback(fallbackAssetPath),
            )
          : _assetOrFallback(fallbackAssetPath),
    );
  }

  Widget _assetOrFallback(String? assetPath) {
    if (assetPath != null && assetPath.isNotEmpty) {
      return Image.asset(
        assetPath,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => _fallback(),
      );
    }

    return _fallback();
  }

  Widget _fallback() {
    final trimmedTeamName = teamName.trim();
    final initial = trimmedTeamName.isEmpty ? '?' : trimmedTeamName.substring(0, 1);

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: YouthFieldColor.black50,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: const TextStyle(
          color: YouthFieldColor.black500,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
