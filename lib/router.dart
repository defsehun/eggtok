import 'package:go_router/go_router.dart';
import 'package:street_workout/features/videos/camera_awesome_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => const CameraAwesomeScreen(),
    )
  ],
);
