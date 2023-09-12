import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:street_workout/features/authentication/repos/authentication_repo.dart';
import 'package:street_workout/features/users/repos/user_repo.dart';
import 'package:street_workout/features/users/view_model/users_view_model.dart';
import 'package:street_workout/utils.dart';

class AvatarViewModel extends AsyncNotifier<void> {
  late final UserRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.read(userRepo);
  }

  Future<void> uploadAvatar(File file, BuildContext context) async {
    state = const AsyncValue.loading();
    final fileName = ref.read(authRepo).user!.uid;
    state = await AsyncValue.guard(
      () async {
        await _repository.uploadAvatar(file, fileName);
        await ref.read(usersProvider.notifier).onAvatarUpload();
      },
    );
    if (state.hasError) {
      showFirebaseErrorSnack(context, state.error);
    }
  }
}

final avatarProvider = AsyncNotifierProvider<AvatarViewModel, void>(
  () => AvatarViewModel(),
);
