import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:street_workout/constants/breakpoint.dart';
import 'package:street_workout/constants/gaps.dart';
import 'package:street_workout/constants/sizes.dart';
import 'package:street_workout/features/authentication/repos/authentication_repo.dart';
import 'package:street_workout/features/inbox/view_models/messages_view_model.dart';
import 'package:street_workout/utils.dart';

class ChatDetailScreen extends ConsumerStatefulWidget {
  static const String routeName = "chatDetail";
  static const String routeURL = ":chatId";

  final String chatId;

  const ChatDetailScreen({super.key, required this.chatId});

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final TextEditingController _editingController = TextEditingController();

  void _stopWriting() {
    FocusScope.of(context).unfocus();
  }

  void _onSendPress() {
    final text = _editingController.text;
    if (text == "") {
      return;
    }
    ref.read(messagesProvider.notifier).sendMessage(text);
    _editingController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(messagesProvider).isLoading;
    final isDark = isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          horizontalTitleGap: Sizes.size8,
          leading: Stack(
            children: [
              const Padding(
                padding: EdgeInsets.all(Sizes.size4),
                child: CircleAvatar(
                  foregroundImage: NetworkImage(
                    "https://avatars.githubusercontent.com/u/17242597?v=4",
                  ),
                  radius: Sizes.size20,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: Sizes.size18,
                  height: Sizes.size18,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    border: Border.all(
                      color: isDark ? Colors.black : Colors.white,
                      width: Sizes.size3,
                    ),
                    borderRadius: BorderRadius.circular(Sizes.size24),
                  ),
                ),
              ),
            ],
          ),
          title: Text(
            "Sehun (${widget.chatId})",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: const Text(
            "Active Now",
            style: TextStyle(
              fontSize: Sizes.size12,
              fontWeight: FontWeight.w400,
            ),
          ),
          trailing: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                FontAwesomeIcons.flag,
                size: Sizes.size20,
              ),
              Gaps.h32,
              FaIcon(
                FontAwesomeIcons.ellipsis,
                size: Sizes.size20,
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: Breakpoints.md,
          ),
          child: GestureDetector(
            onTap: _stopWriting,
            child: Stack(
              children: [
                ref.watch(chatProvider).when(
                      data: (data) {
                        return ListView.separated(
                          reverse: true,
                          padding: EdgeInsets.only(
                            top: Sizes.size20,
                            bottom: MediaQuery.of(context).padding.bottom +
                                Sizes.size96,
                            left: Sizes.size14,
                            right: Sizes.size14,
                          ),
                          itemBuilder: (context, index) {
                            final message = data[index];
                            final isMine =
                                message.userId == ref.watch(authRepo).user!.uid;
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: isMine
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(Sizes.size14),
                                  decoration: BoxDecoration(
                                      color: isMine
                                          ? Colors.blue
                                          : Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.only(
                                        topLeft:
                                            const Radius.circular(Sizes.size20),
                                        topRight:
                                            const Radius.circular(Sizes.size20),
                                        bottomLeft: Radius.circular(isMine
                                            ? Sizes.size20
                                            : Sizes.size5),
                                        bottomRight: Radius.circular(!isMine
                                            ? Sizes.size20
                                            : Sizes.size5),
                                      )),
                                  child: Text(
                                    message.text,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      //fontSize: Sizes.size16,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                          separatorBuilder: (context, index) => Gaps.v10,
                          itemCount: data.length,
                        );
                      },
                      error: (error, stackTrace) => Center(
                        child: Text(error.toString()),
                      ),
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                Positioned(
                  bottom: 0,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    color: isDark ? Colors.black : Colors.grey.shade50,
                    padding: EdgeInsets.only(
                      left: Sizes.size14,
                      right: Sizes.size14,
                      top: Sizes.size10,
                      bottom:
                          MediaQuery.of(context).padding.bottom + Sizes.size20,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: Sizes.size40,
                            child: TextField(
                              controller: _editingController,
                              expands: true,
                              minLines: null,
                              maxLines: null,
                              textInputAction: TextInputAction.newline,
                              cursorColor: Theme.of(context).primaryColor,
                              decoration: InputDecoration(
                                hintText: "Send a message...",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    Sizes.size12,
                                  ),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: Sizes.size2,
                                  horizontal: Sizes.size12,
                                ),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.only(
                                    right: Sizes.size10,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Gaps.h10,
                                      FaIcon(
                                        FontAwesomeIcons.faceSmile,
                                        color:
                                            Theme.of(context).iconTheme.color,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Gaps.h12,
                        IconButton(
                          onPressed: isLoading ? null : _onSendPress,
                          icon: FaIcon(
                            isLoading
                                ? FontAwesomeIcons.hourglass
                                : FontAwesomeIcons.paperPlane,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
