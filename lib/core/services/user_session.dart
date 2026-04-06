import 'dart:typed_data';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:youthfield/features/mypage/domain/entities/user_type.dart';

class UserSession {
  static const _kUserSessionBox = 'user_session';
  static const _nameKey = 'user_name';
  static const _typeKey = 'user_type';
  static const _profileImageKey = 'user_profile_image_bytes';
  static const _staffRoleKey = 'user_staff_role';
  static const _teamKey = 'user_team';
  static const _positionKey = 'user_position';
  static const _birthdateKey = 'user_birthdate';
  static const _resolveKey = 'user_resolve';
  static final UserSession _instance = UserSession._internal();

  factory UserSession() => _instance;

  UserSession._internal();

  String? name;
  Uint8List? profileImageBytes;
  UserType? userType;
  String? staffRole;
  String? team;
  String? position;
  String? birthdate;
  String? resolve;

  bool get hasData => name != null && userType != null;

  Box<dynamic> get _box => Hive.box<dynamic>(_kUserSessionBox);

  Future<void> loadFromPrefs() async {
    name = _box.get(_nameKey) as String?;
    profileImageBytes = _box.get(_profileImageKey) as Uint8List?;
    staffRole = _box.get(_staffRoleKey) as String?;
    team = _box.get(_teamKey) as String?;
    position = _box.get(_positionKey) as String?;
    birthdate = _box.get(_birthdateKey) as String?;
    resolve = _box.get(_resolveKey) as String?;
    final typeStr = _box.get(_typeKey) as String?;
    if (typeStr != null) {
      userType = UserType.values.firstWhere(
        (e) => e.name == typeStr,
        orElse: () => UserType.general,
      );
    }
  }

  void save({
    required String name,
    required UserType userType,
    Uint8List? profileImageBytes,
    String? staffRole,
    String? team,
    String? position,
    String? birthdate,
    String? resolve,
  }) {
    this.name = name;
    this.userType = userType;
    this.profileImageBytes = profileImageBytes;
    this.staffRole = staffRole;
    this.team = team;
    this.position = position;
    this.birthdate = birthdate;
    this.resolve = resolve;
    _persist(
      name: name,
      userType: userType,
      profileImageBytes: profileImageBytes,
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

  Future<void> clear() async {
    name = null;
    userType = null;
    profileImageBytes = null;
    staffRole = null;
    team = null;
    position = null;
    birthdate = null;
    resolve = null;
    for (final key in [
      _nameKey,
      _typeKey,
      _staffRoleKey,
      _teamKey,
      _positionKey,
      _birthdateKey,
      _resolveKey,
      _profileImageKey,
    ]) {
      await _box.delete(key);
    }
  }
}
