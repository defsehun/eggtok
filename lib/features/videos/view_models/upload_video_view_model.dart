import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:street_workout/features/authentication/repos/authentication_repo.dart';
import 'package:street_workout/features/users/view_model/users_view_model.dart';
import 'package:street_workout/features/videos/models/video_model.dart';
import 'package:street_workout/features/videos/repos/videos.repo.dart';

class UploadVideoViewModel extends AsyncNotifier<void> {
  late final VideoRepositoty _repositoty;

  @override
  FutureOr<void> build() {
    _repositoty = ref.read(videoRepo);
  }

  Future<void> uploadVideo(File video, BuildContext context) async {
    final user = ref.read(authRepo).user;
    final userProfile = ref.read(usersProvider).value;

    if (userProfile != null) {
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(() async {
        final task = await _repositoty.uploadVideoFile(
          video,
          user!.uid,
        );
        if (task.metadata != null) {
          await _repositoty.saveVideo(
            VideoModel(
              id: "",
              title: "${userProfile.name}'s video!",
              description: "createdAt: ${DateTime.now().toString()}",
              fileUrl: await task.ref.getDownloadURL(),
              thumbnailUrl: "",
              creatorUid: user.uid,
              likes: 0,
              comments: 0,
              createdAt: DateTime.now().millisecondsSinceEpoch,
              creator: userProfile.name,
            ),
          );
          // context.pushReplacement("/home");
          context.pop();
          context.pop();
        }
      });
    }
  }
}

final uploadVideoProvider = AsyncNotifierProvider<UploadVideoViewModel, void>(
  () => UploadVideoViewModel(),
);
