import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:street_workout/features/videos/models/video_model.dart';
import 'package:street_workout/features/videos/repos/videos.repo.dart';

class TimelineViewModel extends AsyncNotifier<List<VideoModel>> {
  late final VideoRepositoty _repositoty;
  List<VideoModel> _list = [];

  FutureOr<List<VideoModel>> _fetchVideos({
    int? lastItemCreatedAt,
  }) async {
    final result = await _repositoty.fetchVideos(
      lastItemCreatedAt: lastItemCreatedAt,
    );
    final videos = result.docs.map(
      (doc) => VideoModel.fromJson(
        json: doc.data(),
        videoId: doc.id,
      ),
    );
    return videos.toList();
  }

  @override
  FutureOr<List<VideoModel>> build() async {
    _repositoty = ref.read(videoRepo);
    _list = await _fetchVideos(lastItemCreatedAt: null);
    return _list;
  }

  Future<void> fetchNextPage() async {
    final nextPage =
        await _fetchVideos(lastItemCreatedAt: _list.last.createdAt);
    _list.addAll(nextPage);
    state = AsyncValue.data(_list);
  }

  Future<void> refresh() async {
    final videos = await _fetchVideos(lastItemCreatedAt: null);
    _list = videos;
    state = AsyncValue.data(videos);
  }
}

final timelineProvider =
    AsyncNotifierProvider<TimelineViewModel, List<VideoModel>>(
  () => TimelineViewModel(),
);
