import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youthfield/core/providers/user_session_provider.dart';
import 'package:youthfield/features/diary/presentation/providers/diary_provider.dart';
import 'package:youthfield/features/mypage/data/repositories/mypage_repository_impl.dart';
import 'package:youthfield/features/mypage/domain/entities/user_profile.dart';
import 'package:youthfield/features/mypage/domain/usecases/get_my_profile_usecase.dart';

final myProfileProvider = FutureProvider<UserProfile>((ref) async {
  final session = ref.watch(userSessionProvider);
  final diaries = ref.watch(diaryProvider);
  return GetMyProfileUsecase(
    UserSessionRepository(session: session, diaries: diaries),
  )();
});
