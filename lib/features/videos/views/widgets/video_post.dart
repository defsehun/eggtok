import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:street_workout/constants/breakpoint.dart';
import 'package:street_workout/constants/gaps.dart';
import 'package:street_workout/constants/sizes.dart';
import 'package:street_workout/features/videos/models/video_model.dart';
import 'package:street_workout/features/videos/view_models/playback_config_vm.dart';
import 'package:street_workout/features/videos/view_models/video_post_view_model.dart';
import 'package:street_workout/features/videos/views/widgets/video_button.dart';
import 'package:street_workout/features/videos/views/widgets/video_comments.dart';
import 'package:street_workout/features/videos/views/widgets/video_tag_info.dart';
import 'package:street_workout/generated/l10n.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPost extends ConsumerStatefulWidget {
  final Function onVideoFinished;
  final VideoModel videoData;
  final int index;

  const VideoPost({
    super.key,
    required this.videoData,
    required this.onVideoFinished,
    required this.index,
  });

  @override
  VideoPostState createState() => VideoPostState();
}

class VideoPostState extends ConsumerState<VideoPost>
    with SingleTickerProviderStateMixin {
  late final VideoPlayerController _videoPlayerController;

  final Duration _animationDuration = const Duration(milliseconds: 200);
  late final AnimationController _animationController;

  bool _isPaused = false;
  int _likeCount = 0;

  final List<String> tags = [
    "sans",
    "dua lipa",
    "Levitating!!!!",
    "Levitating",
    "두아",
    "concert",
  ];

  final String bgmInfo = 'Dua Lipa - Levitating (2020)';

  void _onVideoChange() {
    if (_videoPlayerController.value.isInitialized) {
      if (_videoPlayerController.value.duration ==
          _videoPlayerController.value.position) {
        widget.onVideoFinished();
      }
    }
  }

  Future<void> _onLikeTap(BuildContext context) async {
    Future<bool> isLiked = ref
        .read(videoPostProvider(widget.videoData.id).notifier)
        .toggleLikeVideo();
    if (await isLiked) {
      _likeCount++;
    } else {
      _likeCount--;
    }
    setState(() {});
  }

  void _initVideoPlayer() async {
    _videoPlayerController =
        VideoPlayerController.network(widget.videoData.fileUrl);

    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);

    // FIXME: _likeCount 실시간으로 변경되었을때 다시 받아오는 로직 필요.
    // fetch currunt videoData
    _likeCount = widget.videoData.likes;
    _videoPlayerController.addListener(_onVideoChange);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();

    _animationController = AnimationController(
      vsync: this,
      lowerBound: 1.0,
      upperBound: 1.5,
      value: 1.5,
      duration: _animationDuration,
    );

    _initMute();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _initMute() {
    // if (kIsWeb) {
    //   _videoPlayerController.setVolume(0);
    // }
    final muted = ref.read(playbackConfigProvider).muted;
    _videoPlayerController.setVolume(muted ? 0 : 1);
  }

  // FIXME: need refactor
  void _onPlaybackConfigChanged() {
    if (!mounted) return;

    final muted = ref.read(playbackConfigProvider).muted;
    ref.read(playbackConfigProvider.notifier).setMuted(!muted);
    _videoPlayerController.setVolume(!muted ? 0 : 1);
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!mounted) return;

    if (info.visibleFraction == 1 &&
        !_isPaused &&
        !_videoPlayerController.value.isPlaying) {
      if (ref.read(playbackConfigProvider).autoplay) {
        _videoPlayerController.play();
      }
    } else if (info.visibleFraction == 0 &&
        _videoPlayerController.value.isPlaying) {
      _onTogglePause();
    } else if (info.visibleFraction == 1 &&
        !_videoPlayerController.value.isPlaying) {
      _onTogglePause();
    }
  }

  void _onTogglePause() {
    if (_videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
      _animationController.reverse();
    } else {
      _videoPlayerController.play();
      _animationController.forward();
    }
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _onCommentsTap(BuildContext context) async {
    if (_videoPlayerController.value.isPlaying) {
      _onTogglePause();
    }
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Center(
        heightFactor: 1.0,
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: Breakpoints.lg,
          ),
          child: const VideoComments(),
        ),
      ),
    );
    _onTogglePause();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key("${widget.index}"),
      onVisibilityChanged: _onVisibilityChanged,
      child: Stack(
        children: [
          Positioned.fill(
            child: _videoPlayerController.value.isInitialized
                ? Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      VideoPlayer(_videoPlayerController),
                      VideoProgressIndicator(
                        _videoPlayerController,
                        allowScrubbing: true,
                      ),
                    ],
                  )
                : Image.network(
                    widget.videoData.thumbnailUrl,
                    fit: BoxFit.cover,
                  ),
          ),
          Positioned.fill(
            child: GestureDetector(
              onTap: _onTogglePause,
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _animationController.value,
                      child: child,
                    );
                  },
                  child: AnimatedOpacity(
                    opacity: _isPaused ? 1 : 0,
                    duration: _animationDuration,
                    child: const FaIcon(
                      FontAwesomeIcons.play,
                      color: Colors.white,
                      size: Sizes.size52,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: Sizes.size10,
            top: Sizes.size40,
            child: IconButton(
              icon: FaIcon(
                ref.watch(playbackConfigProvider).muted
                    ? FontAwesomeIcons.volumeXmark
                    : FontAwesomeIcons.volumeHigh,
                color: Colors.white,
              ),
              onPressed: _onPlaybackConfigChanged,
            ),
          ),
          Positioned(
            bottom: 20,
            left: 10,
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "@${widget.videoData.creator}",
                    style: const TextStyle(
                      fontSize: Sizes.size18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Gaps.v10,
                  Text(
                    widget.videoData.description,
                    style: const TextStyle(
                      fontSize: Sizes.size16,
                      color: Colors.white,
                    ),
                  ),
                  Gaps.v10,
                  VideoTagInfo(desc: tags.map((tag) => '#$tag').join(', ')),
                  Gaps.v10,
                  // SizedBox(
                  //   height: 30,
                  //   width: MediaQuery.of(context).size.width - 100,
                  //   child: VideoBgmInfo(bgmInfo: bgmInfo),
                  // ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: Sizes.size20,
            right: Sizes.size10,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  foregroundImage: NetworkImage(
                      "https://firebasestorage.googleapis.com/v0/b/street-workout-project.appspot.com/o/avatars%2F${widget.videoData.creatorUid}?alt=media"),
                  child: Text(widget.videoData.creator),
                ),
                Gaps.v24,
                VideoButton(
                  onTap: _onLikeTap,
                  icon: FontAwesomeIcons.solidHeart,
                  text: S.of(context).likeCount(_likeCount),
                  color: ref.watch(videoPostProvider(widget.videoData.id)).when(
                        data: (isLiked) => isLiked ? Colors.red : Colors.white,
                        error: (error, stackTrace) => Colors.white,
                        loading: () => Colors.white,
                      ),
                ),
                Gaps.v10,
                VideoButton(
                  onTap: _onCommentsTap,
                  icon: FontAwesomeIcons.solidComment,
                  text: S.of(context).commentCount(widget.videoData.comments),
                ),
                Gaps.v10,
                const VideoButton(
                  icon: FontAwesomeIcons.share,
                  text: "Share",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
