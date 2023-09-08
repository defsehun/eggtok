import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:street_workout/constants/breakpoint.dart';
import 'package:street_workout/features/videos/view_models/timeline_view_model.dart';
import 'package:street_workout/features/videos/views/widgets/video_post.dart';

class VideoTimelineScreen extends ConsumerStatefulWidget {
  const VideoTimelineScreen({super.key});

  @override
  VideoTimelineScreenState createState() => VideoTimelineScreenState();
}

class VideoTimelineScreenState extends ConsumerState<VideoTimelineScreen> {
  int _itemCount = 0;

  final PageController _pageController = PageController();
  final Duration _scrollDuration = const Duration(milliseconds: 250);
  final Curve _scrollCurve = Curves.linear;

  void _onPageChanged(int page) {
    _pageController.animateToPage(
      page,
      duration: _scrollDuration,
      curve: _scrollCurve,
    );
    if (page == _itemCount - 1) {
      ref.watch(timelineProvider.notifier).fetchNextPage();
    }
  }

  void _onVideoFinished() {
    return;
    // _pageController.nextPage(
    //   duration: _scrollDuration,
    //   curve: _scrollCurve,
    // );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _onRefesh() {
    // FIXME: https://stackoverflow.com/questions/63888943/flutter-pageview-itemcount-change-causes-pagecontroller-jumptopage-to-jump-to-wr

    return ref.watch(timelineProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(timelineProvider).when(
        loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
        error: (error, stackTrace) => Center(
              child: Text(
                'Could not load videos: $error',
                style: const TextStyle(color: Colors.white),
              ),
            ),
        data: (videos) {
          _itemCount = videos.length;
          return RefreshIndicator(
            onRefresh: _onRefesh,
            displacement: 50,
            edgeOffset: 20,
            color: Theme.of(context).primaryColor,
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              onPageChanged: _onPageChanged,
              itemCount: _itemCount,
              itemBuilder: (context, index) {
                final videoData = videos[index];
                return Center(
                  child: Container(
                    constraints: const BoxConstraints(
                      maxWidth: Breakpoints.lg,
                    ),
                    child: VideoPost(
                      onVideoFinished: _onVideoFinished,
                      index: index,
                      videoData: videoData,
                    ),
                  ),
                );
              },
            ),
          );
        });
  }
}
