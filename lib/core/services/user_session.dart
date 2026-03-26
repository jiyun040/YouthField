import 'dart:typed_data';

import 'package:youthfield/features/mypage/domain/entities/user_type.dart';

class UserSession {
  static final UserSession _instance = UserSession._internal();

  factory UserSession() => _instance;

  UserSession._internal();

  String? name;
  Uint8List? profileImageBytes;
  UserType? userType;
  String? team;
  String? position;
  String? birthdate;
  String? resolve;

  bool get hasData => name != null && userType != null;

  void save({
    required String name,
    required UserType userType,
    Uint8List? profileImageBytes,
    String? team,
    String? position,
    String? birthdate,
    String? resolve,
  }) {
    this.name = name;
    this.userType = userType;
    this.profileImageBytes = profileImageBytes;
    this.team = team;
    this.position = position;
    this.birthdate = birthdate;
    this.resolve = resolve;
  }

  void clear() {
    name = null;
    userType = null;
    profileImageBytes = null;
    team = null;
    position = null;
    birthdate = null;
    resolve = null;
  }
}
