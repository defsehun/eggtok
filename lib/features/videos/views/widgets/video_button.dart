import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:street_workout/constants/gaps.dart';
import 'package:street_workout/constants/sizes.dart';

class VideoButton extends StatelessWidget {
  final IconData icon;
  final String? text;
  final Color? color;
  final Function(BuildContext)? onTap;

  const VideoButton({
    super.key,
    required this.icon,
    this.text,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!(context);
        }
      },
      child: Column(
        children: [
          FaIcon(
            icon,
            color: color ?? Colors.white,
            size: Sizes.size32,
          ),
          Gaps.v2,
          if (text != null)
            Text(
              text!,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: Sizes.size12,
              ),
            ),
        ],
      ),
    );
  }
}
