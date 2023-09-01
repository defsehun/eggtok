import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:street_workout/common/widgets/video_config/video_config.dart';
import 'package:street_workout/constants/breakpoint.dart';
import 'package:street_workout/constants/gaps.dart';
import 'package:street_workout/constants/sizes.dart';
import 'package:street_workout/features/videos/widgets/video_bgm_info.dart';
import 'package:street_workout/features/videos/widgets/video_button.dart';
import 'package:street_workout/features/videos/widgets/video_comments.dart';
import 'package:street_workout/features/videos/widgets/video_tag_info.dart';
import 'package:street_workout/generated/l10n.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPost extends StatefulWidget {
  final Function onVideoFinished;
  final int index;

  const VideoPost({
    super.key,
    required this.onVideoFinished,
    required this.index,
  });

  @override
  State<VideoPost> createState() => _VideoPostState();
}

class _VideoPostState extends State<VideoPost>
    with SingleTickerProviderStateMixin {
  late final VideoPlayerController _videoPlayerController;

  final Duration _animationDuration = const Duration(milliseconds: 200);
  late final AnimationController _animationController;

  bool _isPaused = false;

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

  void _initVideoPlayer() async {
    _videoPlayerController =
        VideoPlayerController.asset("assets/videos/test3.mp4");
    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    if (kIsWeb) {
      await _videoPlayerController.setVolume(0);
    }
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
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!mounted) return;
    if (info.visibleFraction == 1 &&
        !_isPaused &&
        !_videoPlayerController.value.isPlaying) {
      _videoPlayerController.play();
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
                : Container(color: Colors.black),
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
                context.watch<VideoConfig>().isMuted
                    ? FontAwesomeIcons.volumeXmark
                    : FontAwesomeIcons.volumeHigh,
                color: Colors.white,
              ),
              onPressed: () {
                context.read<VideoConfig>().toggleIsMuted();
              },
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
                  const Text(
                    "@iSehun",
                    style: TextStyle(
                      fontSize: Sizes.size18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Gaps.v10,
                  const Text(
                    "두아 리파 1열 관람!!",
                    style: TextStyle(
                      fontSize: Sizes.size16,
                      color: Colors.white,
                    ),
                  ),
                  Gaps.v10,
                  VideoTagInfo(desc: tags.map((tag) => '#$tag').join(', ')),
                  Gaps.v10,
                  SizedBox(
                    height: 30,
                    width: MediaQuery.of(context).size.width - 100,
                    child: VideoBgmInfo(bgmInfo: bgmInfo),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: Sizes.size20,
            right: Sizes.size10,
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  foregroundImage: NetworkImage(
                      "https://avatars.githubusercontent.com/u/17242597?v=4"),
                  child: Text("S"),
                ),
                Gaps.v24,
                VideoButton(
                  icon: FontAwesomeIcons.solidHeart,
                  text: S.of(context).likeCount(29803400),
                ),
                Gaps.v10,
                VideoButton(
                  onTap: _onCommentsTap,
                  icon: FontAwesomeIcons.solidComment,
                  text: S.of(context).commentCount(332400),
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
