import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';
import 'package:youthfield/features/diary/domain/entities/diary_entry.dart';
import 'package:youthfield/features/diary/presentation/widgets/diary_list_row.dart';
import 'package:youthfield/features/mypage/domain/entities/player_stats.dart';
import 'package:youthfield/features/mypage/domain/entities/user_profile.dart';
import 'package:youthfield/features/mypage/presentation/pages/profile_edit_page.dart';
import 'package:youthfield/features/mypage/presentation/providers/mypage_provider.dart';
import 'package:youthfield/features/mypage/presentation/widgets/mypage_profile_header.dart';
import 'package:youthfield/features/mypage/presentation/widgets/mypage_skill_carousel.dart';

class MypagePage extends ConsumerStatefulWidget {
  final VoidCallback? onDiaryMoreTap;
  static const spacing10 = SizedBox(height: 10);
  static const spacing40 = SizedBox(height: 40);

  const MypagePage({super.key, this.onDiaryMoreTap});

  @override
  ConsumerState<MypagePage> createState() => _MypagePageState();
}

class _MypagePageState extends ConsumerState<MypagePage> {
  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(myProfileProvider);
    return Scaffold(
      backgroundColor: YouthFieldColor.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: profileAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('오류가 발생했습니다.')),
              data: (profile) => SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 72),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
                      child: _buildWithProfile(profile),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(top: 0, left: 0, right: 0, child: _buildSubHeader()),
        ],
      ),
    );
  }

  Widget _buildSubHeader() {
    return Container(
      height: 72,
      color: YouthFieldColor.background,
      child: Stack(
        children: [
          Center(child: Text('마이페이지', style: YouthFieldTextStyle.body3)),
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
          Positioned(
            right: 8,
            top: 0,
            bottom: 0,
            child: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(
                  Symbols.edit,
                  color: YouthFieldColor.blue700,
                  size: 24,
                ),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfileEditPage()),
                  );
                  if (mounted) ref.invalidate(myProfileProvider);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWithProfile(UserProfile profile) {
    return switch (profile) {
      PlayerProfile p => _buildPlayerBody(p),
      StaffProfile s => _buildStaffBody(s),
      GeneralProfile g => _buildGeneralBody(g),
    };
  }

  Widget _buildPlayerBody(PlayerProfile profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MypageProfileHeader(profile: profile),
        if (profile.resolve != null && profile.resolve!.isNotEmpty) ...[
          MypagePage.spacing40,
          _ResolveCard(resolve: profile.resolve!),
        ],
        const SizedBox(height: 100),
        _StatsTable(title: '통산기록', stats: profile.seasonStats),
        MypagePage.spacing40,
        _StatsTable(title: '국대기록', stats: profile.nationalStats),
        MypagePage.spacing40,
        MypageSkillCarousel(skills: profile.watchedSkills),
        MypagePage.spacing40,
        _buildDiarySection(profile.recentDiaries),
      ],
    );
  }

  Widget _buildStaffBody(StaffProfile profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MypageProfileHeader(profile: profile),
        MypagePage.spacing40,
        MypageSkillCarousel(skills: profile.watchedSkills),
        MypagePage.spacing40,
        _buildDiarySection(profile.recentDiaries),
      ],
    );
  }

  Widget _buildGeneralBody(GeneralProfile profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MypageProfileHeader(profile: profile),
        MypagePage.spacing40,
        MypageSkillCarousel(skills: profile.watchedSkills),
        MypagePage.spacing40,
        _buildDiarySection(profile.recentDiaries),
      ],
    );
  }

  Widget _buildDiarySection(List<DiaryEntry> diaries) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('작성한 일지', style: YouthFieldTextStyle.body4),
            GestureDetector(
              onTap: widget.onDiaryMoreTap == null
                  ? null
                  : () {
                      widget.onDiaryMoreTap!.call();
                      Navigator.pop(context);
                    },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Text(
                  '더보기',
                  style: YouthFieldTextStyle.smallButton.copyWith(
                    color: YouthFieldColor.blue700,
                  ),
                ),
              ),
            ),
          ],
        ),
        MypagePage.spacing10,
        ...diaries.map((entry) => DiaryListRow(entry: entry, onTap: () {})),
      ],
    );
  }
}

class _StatsTable extends StatelessWidget {
  final String title;
  final PlayerStats stats;

  const _StatsTable({required this.title, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: YouthFieldTextStyle.body4),
        MypagePage.spacing10,
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: YouthFieldColor.black50),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Table(
              border: TableBorder.symmetric(
                inside: const BorderSide(color: YouthFieldColor.black50),
              ),
              children: [
                TableRow(
                  decoration: const BoxDecoration(
                    color: YouthFieldColor.black50,
                  ),
                  children: const [
                    _TableCell(text: '출장', isHeader: true),
                    _TableCell(text: '골', isHeader: true),
                    _TableCell(text: '도움', isHeader: true),
                    _TableCell(text: '경고', isHeader: true),
                    _TableCell(text: '퇴장', isHeader: true),
                  ],
                ),
                TableRow(
                  children: [
                    _TableCell(text: '${stats.appearances}'),
                    _TableCell(text: '${stats.goals}'),
                    _TableCell(text: '${stats.assists}'),
                    _TableCell(text: '${stats.yellowCards}'),
                    _TableCell(text: '${stats.redCards}'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TableCell extends StatelessWidget {
  final String text;
  final bool isHeader;

  const _TableCell({required this.text, this.isHeader = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Text(
          text,
          style: (isHeader
              ? YouthFieldTextStyle.smallButton
              : YouthFieldTextStyle.textCount),
        ),
      ),
    );
  }
}

class _ResolveCard extends StatelessWidget {
  final String resolve;

  const _ResolveCard({required this.resolve});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '나의 각오',
          style: YouthFieldTextStyle.smallButton.copyWith(
            color: YouthFieldColor.blue700,
          ),
        ),
        MypagePage.spacing10,
        Text(resolve, style: YouthFieldTextStyle.textCount),
      ],
    );
  }
}
