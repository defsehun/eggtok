import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:street_workout/constants/sizes.dart';
import 'package:street_workout/features/users/models/user_profile_model.dart';
import 'package:street_workout/features/users/view_model/user_list_view_model.dart';

class CreateChatScreen extends ConsumerStatefulWidget {
  const CreateChatScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateChatScreenState();
}

class _CreateChatScreenState extends ConsumerState<CreateChatScreen> {
  void _onListTap(UserProfileModel user) {
    Navigator.pop(context, user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text("New message"),
      ),
      body: ref.watch(userListProvider).when(
            data: (users) => ListView(
              children: users.map((user) {
                return Padding(
                  padding: const EdgeInsets.all(2),
                  child: ListTile(
                    onTap: () => _onListTap(user),
                    leading: FittedBox(
                      child: CircleAvatar(
                        radius: Sizes.size26,
                        foregroundImage: NetworkImage(
                            "https://firebasestorage.googleapis.com/v0/b/street-workout-project.appspot.com/o/avatars%2F${user.uid}?alt=media"),
                        child: Text(user.name.substring(0, 3)),
                      ),
                    ),
                    title: Text(
                      user.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }).toList(),
            ),
            error: (error, stackTrace) => Center(
              child: Text(error.toString()),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
    );
  }
}
