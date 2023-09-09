import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:street_workout/constants/breakpoint.dart';
import 'package:street_workout/constants/sizes.dart';
import 'package:street_workout/features/inbox/views/chat_detail_screen.dart';
import 'package:street_workout/features/inbox/views/create_chat_screen.dart';
import 'package:street_workout/features/users/models/user_profile_model.dart';

class ChatsScreen extends StatefulWidget {
  static const String routeName = "chats";
  static const String routeURL = "/chats";

  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final GlobalKey<AnimatedListState> _key = GlobalKey<AnimatedListState>();
  final List<UserProfileModel> _items = [];
  final Duration _duration = const Duration(milliseconds: 300);

  void _addItem(UserProfileModel opponent) {
    if (_key.currentState != null) {
      _key.currentState!.insertItem(0, duration: _duration);
      _items.add(opponent);
    }
  }

  void _deleteItem(int index) {
    if (_key.currentState != null) {
      _key.currentState!.removeItem(
        index,
        (context, animation) => SizeTransition(
          sizeFactor: animation,
          child: Container(
            color: Colors.red,
            child: _makeTile(index),
          ),
        ),
        duration: _duration,
      );
      _items.removeAt(index);
    }
  }

  void _onCreateChatPressed() async {
    final UserProfileModel? opponent = await Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => const CreateChatScreen(),
      ),
    );

    if (opponent != null) {
      _addItem(opponent);

      if (!mounted) return;
      // FIXME: change chatId
      context.pushNamed(ChatDetailScreen.routeName,
          params: {"chatId": opponent.uid});
    }
  }

  void _onChatTap(int index) {
    context.pushNamed(ChatDetailScreen.routeName, params: {"chatId": "$index"});
  }

  Widget _makeTile(int index) {
    final user = _items[index];
    return ListTile(
      onTap: () => _onChatTap(index),
      onLongPress: () => _deleteItem(index),
      leading: CircleAvatar(
        radius: 30,
        foregroundImage: NetworkImage(
          "https://firebasestorage.googleapis.com/v0/b/street-workout-project.appspot.com/o/avatars%2F${user.uid}?alt=media",
        ),
        child: Text(user.name.substring(0, 3)),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            user.name,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "2:16 PM",
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: Sizes.size12,
            ),
          ),
        ],
      ),
      subtitle: const Text("아직 생성되지 않은 채팅방"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text("Direct messages"),
        actions: [
          IconButton(
            onPressed: _onCreateChatPressed,
            icon: const FaIcon(
              FontAwesomeIcons.plus,
            ),
          ),
        ],
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: Breakpoints.md,
          ),
          child: AnimatedList(
            key: _key,
            padding: const EdgeInsets.symmetric(vertical: Sizes.size10),
            itemBuilder: (context, index, animation) {
              return FadeTransition(
                key: UniqueKey(),
                opacity: animation,
                child: SizeTransition(
                  sizeFactor: animation,
                  child: _makeTile(index),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
