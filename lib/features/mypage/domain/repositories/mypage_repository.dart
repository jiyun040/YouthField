import 'package:youthfield/features/mypage/domain/entities/user_profile.dart';

abstract interface class MypageRepository {
  Future<UserProfile> getMyProfile();
}
