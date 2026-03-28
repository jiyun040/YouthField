import 'dart:typed_data';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:youthfield/features/mypage/domain/entities/user_type.dart';

class UserSession {
  static final UserSession _instance = UserSession._internal();

  factory UserSession() => _instance;

  UserSession._internal();

  String? name;
  Uint8List? profileImageBytes;
  UserType? userType;
  String? staffRole; // '감독' or '코치' (UserType.staff 일 때만)
  String? team;
  String? position;
  String? birthdate;
  String? resolve;

  bool get hasData => name != null && userType != null;

  // 앱 시작 시 또는 로그인 감지 시 호출
  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    name = prefs.getString('user_name');
    staffRole = prefs.getString('user_staff_role');
    team = prefs.getString('user_team');
    position = prefs.getString('user_position');
    birthdate = prefs.getString('user_birthdate');
    resolve = prefs.getString('user_resolve');
    final typeStr = prefs.getString('user_type');
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
    name = null;
    userType = null;
    profileImageBytes = null;
    staffRole = null;
    team = null;
    position = null;
    birthdate = null;
    resolve = null;
    final prefs = await SharedPreferences.getInstance();
    for (final key in [
      'user_name', 'user_type', 'user_staff_role',
      'user_team', 'user_position', 'user_birthdate', 'user_resolve',
    ]) {
      await prefs.remove(key);
    }
  }
}
