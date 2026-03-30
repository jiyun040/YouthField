import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';
import 'package:youthfield/core/services/user_session.dart';
import 'package:youthfield/features/auth/presentation/providers/profile_setup_provider.dart';
import 'package:youthfield/features/auth/presentation/widgets/auth_button.dart';
import 'package:youthfield/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:youthfield/features/main/presentation/pages/main_page.dart';
import 'package:youthfield/features/mypage/domain/entities/user_type.dart';
import 'package:youthfield/features/mypage/presentation/providers/mypage_provider.dart';

enum _UserRole { player, manager, coach, fan }

class _Spacing {
  static const h10 = SizedBox(height: 10);
  static const h20 = SizedBox(height: 20);
  static const h40 = SizedBox(height: 40);
}

class ProfileSetupPage extends ConsumerStatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  ConsumerState<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends ConsumerState<ProfileSetupPage> {
  _UserRole? _selectedRole;
  final _nameController = TextEditingController();
  final _teamController = TextEditingController();
  final _birthdateController = TextEditingController();
  final _resolveController = TextEditingController();

  static const _roles = [
    (_UserRole.player, '선수'),
    (_UserRole.manager, '감독'),
    (_UserRole.coach, '코치'),
    (_UserRole.fan, '팬, 가족•지인'),
  ];

  static const _positions = ['GK', 'DF', 'MF', 'FW'];

  bool get _needsTeam =>
      _selectedRole == _UserRole.player ||
      _selectedRole == _UserRole.manager ||
      _selectedRole == _UserRole.coach;

  bool get _isPlayer => _selectedRole == _UserRole.player;

  bool get _canSubmit {
    final setupState = ref.read(profileSetupProvider);
    if (_selectedRole == null) return false;
    if (_nameController.text.trim().isEmpty) return false;
    if (_needsTeam && _teamController.text.trim().isEmpty) return false;
    if (_isPlayer && setupState.position == null) return false;
    if (_isPlayer && _birthdateController.text.trim().isEmpty) return false;
    return true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _teamController.dispose();
    _birthdateController.dispose();
    _resolveController.dispose();
    super.dispose();
  }

  Future<void> _pickProfileImage() async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
      );
      if (image == null) return;
      final bytes = await image.readAsBytes();
      if (bytes.isNotEmpty) {
        ref.read(profileSetupProvider.notifier).setProfileImage(bytes);
      }
    } catch (_) {}
  }

  void _onComplete() {
    if (!_canSubmit) return;

    final setupState = ref.read(profileSetupProvider);

    final userType = switch (_selectedRole!) {
      _UserRole.player => UserType.player,
      _UserRole.manager || _UserRole.coach => UserType.staff,
      _UserRole.fan => UserType.general,
    };

    final staffRole = switch (_selectedRole!) {
      _UserRole.manager => '감독',
      _UserRole.coach => '코치',
      _ => null,
    };

    UserSession().save(
      name: _nameController.text.trim(),
      userType: userType,
      profileImageBytes: setupState.profileImageBytes,
      staffRole: staffRole,
      team: _teamController.text.trim().isEmpty
          ? null
          : _teamController.text.trim().replaceAll(' ', ''),
      position: setupState.position,
      birthdate: _birthdateController.text.trim().isEmpty
          ? null
          : _birthdateController.text.trim(),
      resolve: _resolveController.text.trim().isEmpty
          ? null
          : _resolveController.text.trim(),
    );

    ref.invalidate(myProfileProvider);
    ref.read(profileSetupProvider.notifier).reset();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainPage()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final setupState = ref.watch(profileSetupProvider);
    final profileImageBytes = setupState.profileImageBytes;
    final selectedPosition = setupState.position;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/svg/background.png',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                Container(color: YouthFieldColor.blue700),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Color(0xCC00255E), Color(0x6687B6FF)],
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(
                Symbols.arrow_back_ios,
                color: YouthFieldColor.white,
                size: 36,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 72, 24, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          '프로필 설정',
                          style: YouthFieldTextStyle.body3.copyWith(
                            color: YouthFieldColor.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      _Spacing.h10,
                      Center(
                        child: Text(
                          '어떤 역할로 활동하시나요?',
                          style: YouthFieldTextStyle.placeholder.copyWith(
                            color: YouthFieldColor.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                      _Spacing.h40,
                      Center(
                        child: _ProfileImagePicker(
                          imageBytes: profileImageBytes,
                          onTap: _pickProfileImage,
                        ),
                      ),
                      _Spacing.h40,
                      SizedBox(
                        width: double.infinity,
                        child: _RoleSelector(
                          roles: _roles,
                          selected: _selectedRole,
                          onSelect: (role) {
                            setState(() {
                              _selectedRole = role;
                            });
                            ref.read(profileSetupProvider.notifier).setUserType(
                              switch (role) {
                                _UserRole.player => UserType.player,
                                _UserRole.manager ||
                                _UserRole.coach => UserType.staff,
                                _UserRole.fan => UserType.general,
                              },
                            );
                          },
                        ),
                      ),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        child: _selectedRole == null
                            ? const SizedBox.shrink()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _Spacing.h40,
                                  if (_needsTeam)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 10,
                                      ),
                                      child: Text(
                                        '실제로 등록된 프로필로 사진을 올려주세요.',
                                        style: YouthFieldTextStyle.placeholder
                                            .copyWith(
                                              color: YouthFieldColor.white
                                                  .withValues(alpha: 0.7),
                                            ),
                                      ),
                                    ),
                                  _FieldLabel('이름'),
                                  _Spacing.h10,
                                  AuthTextField(
                                    controller: _nameController,
                                    hint: '이름을 입력해주세요.',
                                  ),
                                  if (_needsTeam) ...[
                                    _Spacing.h20,
                                    _FieldLabel('소속팀'),
                                    _Spacing.h10,
                                    AuthTextField(
                                      controller: _teamController,
                                      hint: '소속팀을 입력해주세요. ex) 부산아이파크U15',
                                    ),
                                  ],
                                  if (_isPlayer) ...[
                                    _Spacing.h20,
                                    _FieldLabel('포지션'),
                                    _Spacing.h10,
                                    _PositionSelector(
                                      positions: _positions,
                                      selected: selectedPosition,
                                      onSelect: (p) => ref
                                          .read(profileSetupProvider.notifier)
                                          .setPosition(p),
                                    ),
                                    _Spacing.h20,
                                    _FieldLabel('생년월일'),
                                    _Spacing.h10,
                                    AuthTextField(
                                      controller: _birthdateController,
                                      hint: 'ex) 20080630',
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                          RegExp(r'[\d.]'),
                                        ),
                                        LengthLimitingTextInputFormatter(10),
                                      ],
                                    ),
                                    _Spacing.h20,
                                    _FieldLabel('각오'),
                                    _Spacing.h10,
                                    AuthTextField(
                                      controller: _resolveController,
                                      hint: '나의 각오를 입력해주세요.',
                                    ),
                                  ],
                                  _Spacing.h40,
                                  ListenableBuilder(
                                    listenable: Listenable.merge([
                                      _nameController,
                                      _teamController,
                                      _birthdateController,
                                      _resolveController,
                                    ]),
                                    builder: (context, _) => AuthButton(
                                      label: '완료',
                                      backgroundColor: _canSubmit
                                          ? YouthFieldColor.gold
                                          : YouthFieldColor.white.withValues(
                                              alpha: 0.3,
                                            ),
                                      labelColor: YouthFieldColor.white,
                                      onTap: _onComplete,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileImagePicker extends StatelessWidget {
  final Uint8List? imageBytes;
  final VoidCallback onTap;

  const _ProfileImagePicker({required this.imageBytes, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 44,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              backgroundImage: imageBytes != null
                  ? MemoryImage(imageBytes!)
                  : null,
              child: imageBytes == null
                  ? const Icon(Symbols.person, size: 40, color: Colors.white)
                  : null,
            ),
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: YouthFieldColor.gold,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: const Icon(
                Symbols.add_a_photo,
                size: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: YouthFieldTextStyle.smallButton.copyWith(
        color: YouthFieldColor.white,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _RoleSelector extends StatelessWidget {
  final List<(_UserRole, String)> roles;
  final _UserRole? selected;
  final ValueChanged<_UserRole> onSelect;

  const _RoleSelector({
    required this.roles,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      runSpacing: 10,
      children: roles.map((r) {
        final isSelected = selected == r.$1;
        return _PillButton(
          label: r.$2,
          isSelected: isSelected,
          onTap: () => onSelect(r.$1),
        );
      }).toList(),
    );
  }
}

class _PositionSelector extends StatelessWidget {
  final List<String> positions;
  final String? selected;
  final ValueChanged<String> onSelect;

  const _PositionSelector({
    required this.positions,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: positions.map((p) {
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: _PillButton(
            label: p,
            isSelected: selected == p,
            onTap: () => onSelect(p),
          ),
        );
      }).toList(),
    );
  }
}

class _PillButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PillButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? YouthFieldColor.gold
                : Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: isSelected
                  ? YouthFieldColor.gold
                  : Colors.white.withValues(alpha: 0.4),
            ),
          ),
          child: Text(
            label,
            style: YouthFieldTextStyle.smallButton.copyWith(
              color: YouthFieldColor.white,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
