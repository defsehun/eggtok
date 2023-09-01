import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:street_workout/constants/sizes.dart';

class VideoTagInfo extends StatelessWidget {
  const VideoTagInfo({
    super.key,
    required String desc,
  }) : _text = desc;

  final String _text;

  @override
  Widget build(BuildContext context) {
    return ReadMoreText(
      _text,
      trimLines: 1,
      colorClickableText: Colors.white,
      trimMode: TrimMode.Line,
      trimCollapsedText: ' See more',
      trimExpandedText: ' Less',
      style: const TextStyle(
        color: Colors.white,
        fontSize: Sizes.size16,
      ),
      moreStyle: const TextStyle(
          color: Colors.white,
          fontSize: Sizes.size16,
          fontWeight: FontWeight.bold),
      lessStyle: const TextStyle(
          color: Colors.white,
          fontSize: Sizes.size16,
          fontWeight: FontWeight.bold),
    );
  }
}
