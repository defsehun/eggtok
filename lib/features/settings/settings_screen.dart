import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:street_workout/constants/breakpoint.dart';
import 'package:street_workout/features/videos/view_models/playback_config_vm.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: Breakpoints.sm,
          ),
          child: ListView(
            children: [
              SwitchListTile.adaptive(
                value: ref.watch(playbackConfigProvider).muted,
                onChanged: (value) => {
                  ref.read(playbackConfigProvider.notifier).setMuted(value),
                },
                title: const Text("Mute video"),
                subtitle: const Text("Videos will be muted by default."),
              ),
              SwitchListTile.adaptive(
                value: ref.watch(playbackConfigProvider).autoplay,
                onChanged: (value) => {
                  ref.read(playbackConfigProvider.notifier).setAutoplay(value),
                },
                title: const Text("Autoplay"),
                subtitle: const Text("Videos will start playing automatically"),
              ),
              SwitchListTile.adaptive(
                value: false,
                onChanged: (value) {},
                title: const Text("Enable notifications"),
                subtitle: const Text("They will be cute."),
              ),
              CheckboxListTile(
                activeColor: Colors.black,
                //checkColor: Colors.black,
                value: false,
                onChanged: (value) {},
                title: const Text("Marketing emails"),
                subtitle: const Text("We won't spam you."),
              ),
              ListTile(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (kDebugMode) {
                    print(date);
                  }

                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (kDebugMode) {
                    print(time);
                  }

                  final booking = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(1980),
                    lastDate: DateTime(2030),
                    builder: (context, child) {
                      return Theme(
                        data: ThemeData(
                          appBarTheme: const AppBarTheme(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (kDebugMode) {
                    print(booking);
                  }
                },
                title: const Text("What is your birthday?"),
                subtitle: const Text("I need to know!"),
              ),
              ListTile(
                title: const Text("Log out (iOS)"),
                textColor: Colors.red,
                onTap: () {
                  showCupertinoDialog(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                      title: const Text("Are you sure?"),
                      content: const Text("Plx dont go"),
                      actions: [
                        CupertinoDialogAction(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("No"),
                        ),
                        CupertinoDialogAction(
                          onPressed: () => Navigator.of(context).pop(),
                          isDestructiveAction: true,
                          child: const Text("Yes"),
                        ),
                      ],
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text("Log out (Android)"),
                textColor: Colors.red,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      icon: const FaIcon(FontAwesomeIcons.cakeCandles),
                      title: const Text("Are you sure?"),
                      content: const Text("Plx dont go"),
                      actions: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const FaIcon(FontAwesomeIcons.car),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("Yes"),
                        ),
                      ],
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text("Log out (iOS / Bottom)"),
                textColor: Colors.red,
                onTap: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (context) => CupertinoActionSheet(
                      title: const Text("Are you sure?"),
                      message: const Text("Please doooooooont goooooooo"),
                      actions: [
                        CupertinoActionSheetAction(
                          isDefaultAction: true,
                          onPressed: () {},
                          child: const Text("Not log out"),
                        ),
                        CupertinoActionSheetAction(
                          isDestructiveAction: true,
                          onPressed: () {},
                          child: const Text("Yes plz."),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const AboutListTile(),
            ],
          ),
        ),
      ),
    );
  }
}
