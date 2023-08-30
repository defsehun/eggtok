import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:street_workout/constants/gaps.dart';
import 'package:street_workout/constants/sizes.dart';
import 'package:street_workout/features/videos/widgets/flash_button.dart';

class VideoRecordingScreen extends StatefulWidget {
  const VideoRecordingScreen({super.key});

  @override
  State<VideoRecordingScreen> createState() => _VideoRecordingScreenState();
}

class _VideoRecordingScreenState extends State<VideoRecordingScreen> {
  bool _hasPermission = false;
  bool _deniedPermissions = false;
  bool _isSelfieMode = false;
  late FlashMode _flashMode;

  late CameraController _cameraController;

  Future<void> initCamera() async {
    final cameras = await availableCameras();

    if (cameras.isEmpty) return;

    _cameraController = CameraController(
      cameras[_isSelfieMode ? 1 : 0],
      ResolutionPreset.ultraHigh,
    );

    await _cameraController.initialize();

    _flashMode = _cameraController.value.flashMode;
  }

  Future<void> initPermissions() async {
    final cameraPermission = await Permission.camera.request();
    final micPermission = await Permission.microphone.request();

    final cameraDenied =
        cameraPermission.isDenied || cameraPermission.isPermanentlyDenied;

    final micDenied =
        micPermission.isDenied || micPermission.isPermanentlyDenied;

    if (!cameraDenied && !micDenied) {
      _hasPermission = true;
      await initCamera();
      setState(() {});
    } else {
      _deniedPermissions = true;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    initPermissions();
  }

  Future<void> _toggleSelfieMode() async {
    _isSelfieMode = !_isSelfieMode;
    await initCamera();
    setState(() {});
  }

  Future<void> _setFlashMode(FlashMode newFlashMode) async {
    // FlashMode is not supported in SelfieMode
    if (_isSelfieMode) return;
    await _cameraController.setFlashMode(newFlashMode);
    _flashMode = newFlashMode;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.black,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: !_hasPermission || !_cameraController.value.isInitialized
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    !_deniedPermissions
                        ? "Initializing..."
                        : "The camera and microphone permissions are required.",
                    style: const TextStyle(
                      //color: Colors.white,
                      fontSize: Sizes.size20,
                    ),
                  ),
                  Gaps.v20,
                  if (!_deniedPermissions)
                    const CircularProgressIndicator.adaptive(),
                  if (_deniedPermissions) ...[
                    Gaps.v96,
                    GestureDetector(
                      onTap: () async {
                        await openAppSettings();
                        initPermissions();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(Sizes.size8),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Theme.of(context).dividerColor),
                        ),
                        child: const Text(
                          "Device Permission Settings",
                          style: TextStyle(
                            fontSize: Sizes.size20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              )
            : Stack(
                alignment: Alignment.center,
                children: [
                  CameraPreview(_cameraController),
                  Positioned(
                    top: Sizes.size52,
                    right: Sizes.size10,
                    child: Column(
                      children: [
                        IconButton(
                          iconSize: Sizes.size40,
                          color: Colors.white,
                          onPressed: _toggleSelfieMode,
                          icon: const Icon(
                            Icons.cameraswitch_rounded,
                          ),
                        ),
                        if (!_isSelfieMode) ...[
                          Gaps.v10,
                          FlashButton(
                            onTap: _setFlashMode,
                            flashMode: FlashMode.off,
                            currentMode: _flashMode,
                          ),
                          Gaps.v10,
                          FlashButton(
                            onTap: _setFlashMode,
                            flashMode: FlashMode.always,
                            currentMode: _flashMode,
                          ),
                          Gaps.v10,
                          FlashButton(
                            onTap: _setFlashMode,
                            flashMode: FlashMode.auto,
                            currentMode: _flashMode,
                          ),
                          Gaps.v10,
                          FlashButton(
                            onTap: _setFlashMode,
                            flashMode: FlashMode.torch,
                            currentMode: _flashMode,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
