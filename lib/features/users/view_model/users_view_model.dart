import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:street_workout/features/users/models/user_profile_model.dart';
import 'package:street_workout/features/users/repos/user_repo.dart';

class UsersViewModel extends AsyncNotifier<UserProfileModel> {
  late final UserRepository _repository;

  @override
  FutureOr<UserProfileModel> build() {
    _repository = ref.read(userRepo);
    // 초기값으로 빈값을 넣어준뒤 나중에 fetch
    return UserProfileModel.empty();
  }

  Future<void> createProfile(UserCredential credential) async {
    if (credential.user == null) {
      throw Exception("Account not created");
    }
    state = const AsyncValue.loading();
    final profile = UserProfileModel(
      uid: credential.user!.uid,
      email: credential.user!.email ?? "anon@anon.com",
      name: credential.user!.displayName ?? "Anon",
      bio: "undefined",
      link: "undefined",
    );
    await _repository.createProfile(profile);
    state = AsyncValue.data(profile);
  }
}

final usersProvider = AsyncNotifierProvider<UsersViewModel, UserProfileModel>(
  () => UsersViewModel(),
);
