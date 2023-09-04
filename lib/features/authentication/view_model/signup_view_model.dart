import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:street_workout/features/authentication/repos/authentication_repo.dart';
import 'package:street_workout/features/onboarding/interests_screen.dart';
import 'package:street_workout/features/users/models/user_profile_model.dart';
import 'package:street_workout/features/users/view_model/users_view_model.dart';
import 'package:street_workout/utils.dart';

class SignUpViewModel extends AsyncNotifier<void> {
  late final AuthenticationRepository _authRepo;

  @override
  FutureOr<void> build() {
    _authRepo = ref.read(authRepo);
  }

  Future<void> signUp(BuildContext context) async {
    state = const AsyncValue.loading();
    final form = ref.read(signUpForm);
    final users = ref.read(usersProvider.notifier);
    state = await AsyncValue.guard(
      () async {
        final credential = await _authRepo.emailSignUp(
          form["email"],
          form["password"],
        );

        if (credential.user == null) {
          throw Exception("Account not created");
        }

        final profile = UserProfileModel(
          uid: credential.user!.uid,
          email: credential.user!.email ?? "undefined@undefined.com",
          name: form["username"],
          bio: "undefined",
          link: "undefined",
          birthday: form["birthday"],
        );

        await users.createProfile(profile);
      },
    );
    if (state.hasError) {
      showFirebaseErrorSnack(context, state.error);
    } else {
      context.goNamed(InterestsScreen.routeName);
    }
  }
}

final signUpForm = StateProvider((ref) => {});

final signUpProvider =
    AsyncNotifierProvider<SignUpViewModel, void>(() => SignUpViewModel());
