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

class _VideoRecordingScreenState extends State<VideoRecordingScreen>
    with TickerProviderStateMixin {
  bool _hasPermission = false;
  bool _deniedPermissions = false;
  bool _isSelfieMode = false;

  late FlashMode _flashMode;
  late CameraController _cameraController;

  late final AnimationController _buttonAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );
  late final AnimationController _progressAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
    lowerBound: 0.0,
    upperBound: 1.0,
  );

  late final Animation<double> _buttonAnimation = Tween(
    begin: 1.0,
    end: 1.3,
  ).animate(_buttonAnimationController);

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

    _progressAnimationController.addListener(() {
      setState(() {});
    });
    _progressAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _stopRecording();
      }
    });
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

  void _startRecording(TapDownDetails _) {
    _buttonAnimationController.forward();
    _progressAnimationController.forward();
  }

  void _stopRecording() {
    _buttonAnimationController.reverse();
    _progressAnimationController.reset();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      //backgroundColor: Colors.black,
      body: SizedBox(
        width: size.width,
        height: size.height,
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
                  Positioned(
                    bottom: Sizes.size96,
                    child: GestureDetector(
                      onTapDown: _startRecording,
                      onTapUp: (details) => _stopRecording(),
                      child: ScaleTransition(
                        scale: _buttonAnimation,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: Sizes.size80 + Sizes.size14,
                              height: Sizes.size80 + Sizes.size14,
                              child: CircularProgressIndicator(
                                color: Colors.red.shade400,
                                strokeWidth: Sizes.size6,
                                value: _progressAnimationController.value,
                              ),
                            ),
                            Container(
                              width: Sizes.size80,
                              height: Sizes.size80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red.shade400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
