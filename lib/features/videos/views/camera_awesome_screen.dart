import 'package:better_open_file/better_open_file.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';

class CameraAwesomeScreen extends StatelessWidget {
  const CameraAwesomeScreen({super.key});

  Future<String> _path(CaptureMode mode) async {
    return 'test';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: CameraAwesomeBuilder.awesome(
          saveConfig: SaveConfig.photoAndVideo(
            photoPathBuilder: () => _path(CaptureMode.photo),
            videoPathBuilder: () => _path(CaptureMode.video),
            initialCaptureMode: CaptureMode.photo,
          ),
          enablePhysicalButton: true,
          filter: AwesomeFilter.AddictiveRed,
          flashMode: FlashMode.auto,
          aspectRatio: CameraAspectRatios.ratio_16_9,
          previewFit: CameraPreviewFit.fitWidth,
          onMediaTap: (mediaCapture) {
            OpenFile.open(mediaCapture.filePath);
          },
        ),
      ),
    );
  }
}
