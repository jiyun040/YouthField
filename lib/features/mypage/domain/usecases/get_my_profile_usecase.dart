import 'package:youthfield/features/mypage/domain/entities/user_profile.dart';
import 'package:youthfield/features/mypage/domain/repositories/mypage_repository.dart';

class GetMyProfileUsecase {
  final MypageRepository _repository;

  const GetMyProfileUsecase(this._repository);

  Future<UserProfile> call() => _repository.getMyProfile();
}
