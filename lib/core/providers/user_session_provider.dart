import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:youthfield/core/services/firestore_profile_service.dart';
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
  static const _kUserSessionBox = 'user_session';
  static const _nameKey = 'user_name';
  static const _typeKey = 'user_type';
  static const _profileImageKey = 'user_profile_image_bytes';
  static const _staffRoleKey = 'user_staff_role';
  static const _teamKey = 'user_team';
  static const _positionKey = 'user_position';
  static const _birthdateKey = 'user_birthdate';
  static const _resolveKey = 'user_resolve';
  static const _loginTimestampKey = 'login_timestamp';

  Box<dynamic> get _box => Hive.box<dynamic>(_kUserSessionBox);

  @override
  UserSessionState build() => const UserSessionState();

  Future<void> loadFromPrefs() async {
    final typeStr = _box.get(_typeKey) as String?;
    final userType = typeStr != null
        ? UserType.values.firstWhere(
            (e) => e.name == typeStr,
            orElse: () => UserType.general,
          )
        : null;

    final profileImageBytes = _box.get(_profileImageKey) as Uint8List?;

    state = UserSessionState(
      name: _box.get(_nameKey) as String?,
      profileImageBytes: profileImageBytes,
      staffRole: _box.get(_staffRoleKey) as String?,
      team: _box.get(_teamKey) as String?,
      position: _box.get(_positionKey) as String?,
      birthdate: _box.get(_birthdateKey) as String?,
      resolve: _box.get(_resolveKey) as String?,
      userType: userType,
    );
  }

  Future<void> loadFromFirestore(String uid) async {
    final data = await FirestoreProfileService.loadProfile(uid);
    if (data == null) return;

    final typeStr = data['userType'] as String?;
    final userType = typeStr != null
        ? UserType.values.firstWhere(
            (e) => e.name == typeStr,
            orElse: () => UserType.general,
          )
        : null;

    final name = data['name'] as String?;
    if (name == null || userType == null) return;

    final staffRole = data['staffRole'] as String?;
    final team = data['team'] as String?;
    final position = data['position'] as String?;
    final birthdate = data['birthdate'] as String?;
    final resolve = data['resolve'] as String?;

    await _box.put(_nameKey, name);
    await _box.put(_typeKey, userType.name);
    if (staffRole != null) await _box.put(_staffRoleKey, staffRole);
    if (team != null) await _box.put(_teamKey, team);
    if (position != null) await _box.put(_positionKey, position);
    if (birthdate != null) await _box.put(_birthdateKey, birthdate);
    if (resolve != null) await _box.put(_resolveKey, resolve);

    state = state.copyWith(
      name: name,
      userType: userType,
      staffRole: staffRole,
      team: team,
      position: position,
      birthdate: birthdate,
      resolve: resolve,
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
      profileImageBytes: profileImageBytes ?? state.profileImageBytes,
      staffRole: staffRole,
      team: team,
      position: position,
      birthdate: birthdate,
      resolve: resolve,
    );

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await FirestoreProfileService.saveProfile(
        uid: uid,
        name: name,
        userType: userType.name,
        staffRole: staffRole,
        team: team,
        position: position,
        birthdate: birthdate,
        resolve: resolve,
      );
    }
  }

  Future<void> _persist({
    required String name,
    required UserType userType,
    Uint8List? profileImageBytes,
    String? staffRole,
    String? team,
    String? position,
    String? birthdate,
    String? resolve,
  }) async {
    await _box.put(_nameKey, name);
    await _box.put(_typeKey, userType.name);
    if (profileImageBytes != null) {
      await _box.put(_profileImageKey, profileImageBytes);
    } else {
      await _box.delete(_profileImageKey);
    }
    if (staffRole != null) {
      await _box.put(_staffRoleKey, staffRole);
    } else {
      await _box.delete(_staffRoleKey);
    }
    if (team != null) {
      await _box.put(_teamKey, team);
    } else {
      await _box.delete(_teamKey);
    }
    if (position != null) {
      await _box.put(_positionKey, position);
    } else {
      await _box.delete(_positionKey);
    }
    if (birthdate != null) {
      await _box.put(_birthdateKey, birthdate);
    } else {
      await _box.delete(_birthdateKey);
    }
    if (resolve != null) {
      await _box.put(_resolveKey, resolve);
    } else {
      await _box.delete(_resolveKey);
    }
  }

  Future<void> recordLoginTimestamp() async {
    await _box.put(_loginTimestampKey, DateTime.now().toIso8601String());
  }

  bool isSessionExpired() {
    final raw = _box.get(_loginTimestampKey) as String?;
    if (raw == null) return false;
    final loginTime = DateTime.tryParse(raw);
    if (loginTime == null) return false;
    return DateTime.now().difference(loginTime).inDays >= 7;
  }

  Future<void> clear() async {
    state = const UserSessionState();
    for (final key in [
      _nameKey,
      _typeKey,
      _staffRoleKey,
      _teamKey,
      _positionKey,
      _birthdateKey,
      _resolveKey,
      _profileImageKey,
      _loginTimestampKey,
    ]) {
      await _box.delete(key);
    }
  }
}

final userSessionProvider =
    NotifierProvider<UserSessionNotifier, UserSessionState>(
      UserSessionNotifier.new,
    );
