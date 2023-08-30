import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:street_workout/constants/sizes.dart';

extension on FlashMode {
  IconData getIcon() {
    switch (this) {
      case FlashMode.off:
        return Icons.flash_off_rounded;
      case FlashMode.auto:
        return Icons.flash_auto_rounded;
      case FlashMode.always:
        return Icons.flash_on_rounded;
      case FlashMode.torch:
        return Icons.flashlight_on_rounded;
    }
  }
}

class FlashButton extends StatelessWidget {
  const FlashButton({
    super.key,
    required this.onTap,
    required this.flashMode,
    required this.currentMode,
  });

  final Function(FlashMode) onTap;
  final FlashMode flashMode;
  final FlashMode currentMode;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: Sizes.size40,
      color: currentMode == flashMode ? Colors.amber.shade200 : Colors.white,
      onPressed: () => onTap(flashMode),
      icon: Icon(
        flashMode.getIcon(),
      ),
    );
  }
}
