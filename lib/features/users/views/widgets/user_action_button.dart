import 'package:flutter/material.dart';
import 'package:street_workout/constants/sizes.dart';

class UserActionButton extends StatelessWidget {
  final double? width;
  final Widget content;
  final Color? color;
  final void Function()? _onTap;

  const UserActionButton({
    super.key,
    this.width,
    required this.content,
    this.color,
    onTap,
  }) : _onTap = onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: SizedBox(
        height: Sizes.size48,
        child: Container(
          alignment: Alignment.center,
          width: width,
          decoration: BoxDecoration(
            color: color,
            //border: Border.all(width: 1, color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(
              Sizes.size8,
            ),
          ),
          child: content,
        ),
      ),
    );
  }
}
