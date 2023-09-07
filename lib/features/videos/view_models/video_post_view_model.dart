import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:street_workout/features/authentication/repos/authentication_repo.dart';
import 'package:street_workout/features/videos/repos/videos.repo.dart';

class VideoPostViewModel extends FamilyAsyncNotifier<bool, String> {
  late final VideoRepositoty _repository;
  late final String _videoId;
  bool _isLiked = false;

  @override
  FutureOr<bool> build(String arg) async {
    _videoId = arg;
    _repository = ref.read(videoRepo);

    final user = ref.read(authRepo).user;
    if (user != null) {
      _isLiked = await _repository.isLikedVideo(_videoId, user.uid);
    }

    return _isLiked;
  }

  Future<bool> toggleLikeVideo() async {
    final user = ref.read(authRepo).user;
    state = await AsyncValue.guard(() async {
      await _repository.likeVideo(_videoId, user!.uid);
      _isLiked = !_isLiked;
      return _isLiked;
    });
    return _isLiked;
  }
}

final videoPostProvider =
    AsyncNotifierProvider.family<VideoPostViewModel, bool, String>(
  () => VideoPostViewModel(),
);
