import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:street_workout/features/authentication/repos/authentication_repo.dart';
import 'package:street_workout/features/users/models/user_profile_model.dart';
import 'package:street_workout/features/users/repos/user_repo.dart';

class UserListViewModel extends AsyncNotifier<List<UserProfileModel>> {
  late final UserRepository _userRepository;
  late final AuthenticationRepository _authenticationRepository;

  @override
  FutureOr<List<UserProfileModel>> build() async {
    _authenticationRepository = ref.read(authRepo);
    _userRepository = ref.read(userRepo);
    return await fetchUserList();
  }

  Future<List<UserProfileModel>> fetchUserList() async {
    final user = _authenticationRepository.user;
    return _userRepository.getUserList(user!.uid);
  }
}

final userListProvider =
    AsyncNotifierProvider<UserListViewModel, List<UserProfileModel>>(
        () => UserListViewModel());
