import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youthfield/features/mypage/domain/entities/user_type.dart';

class ProfileSetupState {
  final UserType? userType;
  final String? position;
  final Uint8List? profileImageBytes;

  const ProfileSetupState({
    this.userType,
    this.position,
    this.profileImageBytes,
  });

  ProfileSetupState copyWith({
    UserType? userType,
    String? position,
    Uint8List? profileImageBytes,
    bool clearPosition = false,
  }) {
    return ProfileSetupState(
      userType: userType ?? this.userType,
      position: clearPosition ? null : (position ?? this.position),
      profileImageBytes: profileImageBytes ?? this.profileImageBytes,
    );
  }
}

class ProfileSetupNotifier extends Notifier<ProfileSetupState> {
  @override
  ProfileSetupState build() => const ProfileSetupState();

  void setUserType(UserType type) {
    state = state.copyWith(userType: type, clearPosition: true);
  }

  void setPosition(String pos) {
    state = state.copyWith(position: pos);
  }

  void setProfileImage(Uint8List bytes) {
    state = state.copyWith(profileImageBytes: bytes);
  }

  void reset() {
    state = const ProfileSetupState();
  }
}

final profileSetupProvider =
    NotifierProvider<ProfileSetupNotifier, ProfileSetupState>(
      ProfileSetupNotifier.new,
    );
