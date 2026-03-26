import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youthfield/features/mypage/data/repositories/mypage_repository_impl.dart';
import 'package:youthfield/features/mypage/domain/entities/user_profile.dart';
import 'package:youthfield/features/mypage/domain/usecases/get_my_profile_usecase.dart';

final myProfileProvider = FutureProvider<UserProfile>((ref) async {
  return GetMyProfileUsecase(UserSessionRepository())();
});
