import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youthfield/features/mypage/domain/entities/user_type.dart';

class UserSessionState {
  final String? name;
  final Uint8List? profileImageBytes;
  final UserType? userType;
  final String? staffRole;
  final String? team;
  final String? position;
  final String? birthdate;
  final String? resolve;

  const UserSessionState({
    this.name,
    this.profileImageBytes,
    this.userType,
    this.staffRole,
    this.team,
    this.position,
    this.birthdate,
    this.resolve,
  });

  bool get hasData => name != null && userType != null;

  UserSessionState copyWith({
    String? name,
    Uint8List? profileImageBytes,
    UserType? userType,
    String? staffRole,
    String? team,
    String? position,
    String? birthdate,
    String? resolve,
    bool clearProfileImage = false,
  }) {
    return UserSessionState(
      name: name ?? this.name,
      profileImageBytes: clearProfileImage
          ? null
          : (profileImageBytes ?? this.profileImageBytes),
      userType: userType ?? this.userType,
      staffRole: staffRole ?? this.staffRole,
      team: team ?? this.team,
      position: position ?? this.position,
      birthdate: birthdate ?? this.birthdate,
      resolve: resolve ?? this.resolve,
    );
  }
}

class UserSessionNotifier extends Notifier<UserSessionState> {
  @override
  UserSessionState build() => const UserSessionState();

  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final typeStr = prefs.getString('user_type');
    final userType = typeStr != null
        ? UserType.values.firstWhere(
            (e) => e.name == typeStr,
            orElse: () => UserType.general,
          )
        : null;

    state = UserSessionState(
      name: prefs.getString('user_name'),
      staffRole: prefs.getString('user_staff_role'),
      team: prefs.getString('user_team'),
      position: prefs.getString('user_position'),
      birthdate: prefs.getString('user_birthdate'),
      resolve: prefs.getString('user_resolve'),
      userType: userType,
    );
  }

  Future<void> save({
    required String name,
    required UserType userType,
    Uint8List? profileImageBytes,
    String? staffRole,
    String? team,
    String? position,
    String? birthdate,
    String? resolve,
  }) async {
    state = UserSessionState(
      name: name,
      userType: userType,
      profileImageBytes: profileImageBytes ?? state.profileImageBytes,
      staffRole: staffRole,
      team: team,
      position: position,
      birthdate: birthdate,
      resolve: resolve,
    );
    await _persist(
      name: name,
      userType: userType,
      staffRole: staffRole,
      team: team,
      position: position,
      birthdate: birthdate,
      resolve: resolve,
    );
  }

  Future<void> _persist({
    required String name,
    required UserType userType,
    String? staffRole,
    String? team,
    String? position,
    String? birthdate,
    String? resolve,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    await prefs.setString('user_type', userType.name);
    if (staffRole != null) await prefs.setString('user_staff_role', staffRole);
    if (team != null) await prefs.setString('user_team', team);
    if (position != null) await prefs.setString('user_position', position);
    if (birthdate != null) await prefs.setString('user_birthdate', birthdate);
    if (resolve != null) await prefs.setString('user_resolve', resolve);
  }

  Future<void> clear() async {
    state = const UserSessionState();
    final prefs = await SharedPreferences.getInstance();
    for (final key in [
      'user_name',
      'user_type',
      'user_staff_role',
      'user_team',
      'user_position',
      'user_birthdate',
      'user_resolve',
    ]) {
      await prefs.remove(key);
    }
  }
}

final userSessionProvider =
    NotifierProvider<UserSessionNotifier, UserSessionState>(
      UserSessionNotifier.new,
    );
