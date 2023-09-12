import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:street_workout/features/authentication/repos/authentication_repo.dart';
import 'package:street_workout/features/users/models/user_profile_model.dart';
import 'package:street_workout/features/users/repos/user_repo.dart';

class UsersViewModel extends AsyncNotifier<UserProfileModel> {
  late final UserRepository _userRepository;
  late final AuthenticationRepository _authenticationRepository;

  @override
  FutureOr<UserProfileModel> build() async {
    _userRepository = ref.read(userRepo);
    _authenticationRepository = ref.read(authRepo);

    if (_authenticationRepository.isLoggedIn) {
      final profile = await _userRepository
          .findProfile(_authenticationRepository.user!.uid);
      if (profile != null) {
        return UserProfileModel.fromJson(profile);
      }
    }

    return UserProfileModel.empty();
  }

  Future<void> createProfile(UserProfileModel profile) async {
    state = const AsyncValue.loading();
    await _userRepository.createProfile(profile);
    state = AsyncValue.data(profile);
  }

  Future<void> updateProfile({String? name, String? bio, String? link}) async {
    if (state.value == null) return;
    if (name != null) {
      state = AsyncValue.data(state.value!.copyWith(name: name));
      await _userRepository.updateProfile(state.value!.uid, {"name": name});
    }
    if (bio != null) {
      state = AsyncValue.data(state.value!.copyWith(bio: bio));
      await _userRepository.updateProfile(state.value!.uid, {"bio": bio});
    }
    if (link != null) {
      state = AsyncValue.data(state.value!.copyWith(link: link));
      await _userRepository.updateProfile(state.value!.uid, {"link": link});
    }
  }

  Future<void> onAvatarUpload() async {
    if (state.value == null) return;
    state = AsyncValue.data(state.value!.copyWith(hasAvatar: true));
    await _userRepository.updateProfile(state.value!.uid, {"hasAvatar": true});
  }
}

final usersProvider = AsyncNotifierProvider<UsersViewModel, UserProfileModel>(
  () => UsersViewModel(),
);
