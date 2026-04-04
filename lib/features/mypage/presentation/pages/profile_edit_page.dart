import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';
import 'package:youthfield/core/providers/user_session_provider.dart';
import 'package:youthfield/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:youthfield/features/mypage/domain/entities/user_type.dart';
import 'package:youthfield/features/mypage/presentation/providers/mypage_provider.dart';

class ProfileEditPage extends ConsumerStatefulWidget {
  const ProfileEditPage({super.key});

  @override
  ConsumerState<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends ConsumerState<ProfileEditPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _teamController;
  late final TextEditingController _birthdateController;
  late final TextEditingController _resolveController;

  static const spacing10 = SizedBox(height: 10);
  static const spacing20 = SizedBox(height: 20);
  static const spacing40 = SizedBox(height: 40);

  String? _selectedPosition;
  String? _selectedStaffRole;
  Uint8List? _profileImageBytes;
  UserType _userType = UserType.general;

  static const _positions = ['GK', 'DF', 'MF', 'FW'];
  static const _staffRoles = ['감독', '코치'];

  bool get _isPlayer => _userType == UserType.player;
  bool get _isStaff => _userType == UserType.staff;

  bool get _needsTeam =>
      _userType == UserType.player || _userType == UserType.staff;

  @override
  void initState() {
    super.initState();
    final s = ref.read(userSessionProvider);
    _nameController = TextEditingController(text: s.name ?? '');
    _teamController = TextEditingController(text: s.team ?? '');
    _birthdateController = TextEditingController(text: s.birthdate ?? '');
    _resolveController = TextEditingController(text: s.resolve ?? '');
    _selectedPosition = s.position;
    _selectedStaffRole = s.staffRole;
    _profileImageBytes = s.profileImageBytes;
    _userType = s.userType ?? UserType.general;
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
        imageQuality: 80,
      );
      if (image == null) return;
      final bytes = await image.readAsBytes();
      if (bytes.isNotEmpty) {
        setState(() => _profileImageBytes = bytes);
      }
    } catch (_) {}
  }

  bool get _canSave => _nameController.text.trim().isNotEmpty;

  Future<void> _onSave() async {
    if (!_canSave) return;
    final rawTeam = _teamController.text.trim().replaceAll(' ', '');
    await ref.read(userSessionProvider.notifier).save(
      name: _nameController.text.trim(),
      userType: _userType,
      profileImageBytes: _profileImageBytes,
      staffRole: _isStaff ? _selectedStaffRole : null,
      team: rawTeam.isEmpty ? null : rawTeam,
      position: _selectedPosition,
      birthdate: _birthdateController.text.trim().isEmpty
          ? null
          : _birthdateController.text.trim(),
      resolve: _resolveController.text.trim().isEmpty
          ? null
          : _resolveController.text.trim(),
    );
    ref.invalidate(myProfileProvider);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YouthFieldColor.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 88, 24, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: _buildImagePicker()),
                  spacing10,
                  _FieldLabel('이름'),
                  spacing10,
                  AuthTextField(
                    controller: _nameController,
                    hint: '이름을 입력해주세요.',
                  ),
                  if (_needsTeam) ...[
                    spacing20,
                    _FieldLabel('소속팀'),
                    spacing10,
                    AuthTextField(
                      controller: _teamController,
                      hint: '소속팀을 입력해주세요. ex) 부산아이파크U15',
                    ),
                  ],
                  if (_isStaff) ...[
                    spacing20,
                    _FieldLabel('역할'),
                    spacing10,
                    _PositionSelector(
                      positions: _staffRoles,
                      selected: _selectedStaffRole,
                      onSelect: (r) => setState(() => _selectedStaffRole = r),
                    ),
                  ],
                  if (_isPlayer) ...[
                    spacing20,
                    _FieldLabel('포지션'),
                    spacing10,
                    _PositionSelector(
                      positions: _positions,
                      selected: _selectedPosition,
                      onSelect: (p) => setState(() => _selectedPosition = p),
                    ),
                    spacing20,
                    _FieldLabel('생년월일'),
                    spacing10,
                    AuthTextField(
                      controller: _birthdateController,
                      hint: 'ex) 20080630',
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
                        LengthLimitingTextInputFormatter(10),
                      ],
                    ),
                    spacing20,
                    _FieldLabel('각오'),
                    spacing10,
                    AuthTextField(
                      controller: _resolveController,
                      hint: '나의 각오를 입력해주세요.',
                    ),
                  ],
                  spacing40,
                  ListenableBuilder(
                    listenable: _nameController,
                    builder: (context, _) => SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _canSave ? _onSave : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: YouthFieldColor.blue700,
                          disabledBackgroundColor: YouthFieldColor.black300,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          '저장',
                          style: YouthFieldTextStyle.smallButton.copyWith(
                            color: YouthFieldColor.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
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
          Center(
            child: Text(
              '프로필 수정',
              style: YouthFieldTextStyle.body3.copyWith(
                color: YouthFieldColor.black800,
              ),
            ),
          ),
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
        ],
      ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickProfileImage,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 52,
              backgroundColor: YouthFieldColor.blue50,
              backgroundImage: _profileImageBytes != null
                  ? MemoryImage(_profileImageBytes!)
                  : null,
              child: _profileImageBytes == null
                  ? const Icon(
                      Symbols.person,
                      size: 48,
                      color: YouthFieldColor.black300,
                    )
                  : null,
            ),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: YouthFieldColor.blue700,
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
        color: YouthFieldColor.black800,
        fontWeight: FontWeight.w600,
      ),
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
        final isSelected = selected == p;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () => onSelect(p),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? YouthFieldColor.blue700
                      : YouthFieldColor.white,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: isSelected
                        ? YouthFieldColor.blue700
                        : YouthFieldColor.black300,
                  ),
                ),
                child: Text(
                  p,
                  style: YouthFieldTextStyle.smallButton.copyWith(
                    color: isSelected
                        ? YouthFieldColor.white
                        : YouthFieldColor.black800,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
