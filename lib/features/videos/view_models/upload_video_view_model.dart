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

  Future<void> uploadVideo({
    required BuildContext context,
    required File video,
    required String title,
    required String description,
  }) async {
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
            // TODO: videoId
            VideoModel(
              id: "", // timeline fetchVideos 에서 videos collection의 doc.id 를 넣어 사용한다.
              title: title,
              description: description,
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
          context.pop();
        }
      });
    }
  }
}

final uploadVideoProvider = AsyncNotifierProvider<UploadVideoViewModel, void>(
  () => UploadVideoViewModel(),
);
