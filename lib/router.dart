import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:street_workout/common/widgets/main_navigation/main_navigation_screen.dart';
import 'package:street_workout/features/authentication/login_screen.dart';
import 'package:street_workout/features/authentication/sign_up_screen.dart';
import 'package:street_workout/features/inbox/activity_screen.dart';
import 'package:street_workout/features/inbox/chat_detail_screen.dart';
import 'package:street_workout/features/inbox/chats_screen.dart';
import 'package:street_workout/features/onboarding/interests_screen.dart';
import 'package:street_workout/features/videos/views/video_recording_screen.dart';

final router = GoRouter(
  initialLocation: "/inbox",
  routes: [
    GoRoute(
      name: SignUpScreen.routeName,
      path: SignUpScreen.routeURL,
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      name: LoginScreen.routeName,
      path: LoginScreen.routeURL,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      name: InterestsScreen.routeName,
      path: InterestsScreen.routeURL,
      builder: (context, state) => const InterestsScreen(),
    ),
    GoRoute(
      name: MainNavigaionScreen.routeName,
      path: "/:tab(home|discover|inbox|profile)",
      builder: (context, state) {
        final tab = state.params['tab']!;
        return MainNavigaionScreen(tab: tab);
      },
    ),
    GoRoute(
      name: ActivityScreen.routeName,
      path: ActivityScreen.routeURL,
      builder: (context, state) => const ActivityScreen(),
    ),
    GoRoute(
      name: ChatsScreen.routeName,
      path: ChatsScreen.routeURL,
      builder: (context, state) => const ChatsScreen(),
      routes: [
        GoRoute(
          path: ChatDetailScreen.routeURL,
          name: ChatDetailScreen.routeName,
          builder: (context, state) {
            final chatId = state.params['chatId']!;
            return ChatDetailScreen(
              chatId: chatId,
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: VideoRecordingScreen.routeURL,
      name: VideoRecordingScreen.routeName,
      pageBuilder: (context, state) => CustomTransitionPage(
        transitionDuration: const Duration(milliseconds: 200),
        child: const VideoRecordingScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final position = Tween(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(animation);
          return SlideTransition(
            position: position,
            child: child,
          );
        },
      ),
    ),
  ],
);
