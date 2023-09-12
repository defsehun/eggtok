import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:street_workout/features/authentication/repos/authentication_repo.dart';
import 'package:street_workout/features/inbox/models/message.dart';
import 'package:street_workout/features/inbox/repos/messages_repo.dart';

class MessagesViewModel extends AsyncNotifier<void> {
  late final MessagesRepo _repo;
  @override
  FutureOr<void> build() {
    _repo = ref.read(messagesRepo);
  }

  Future<void> sendMessage(String text) async {
    final user = ref.read(authRepo).user;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final message = MessageModel(
        text: text,
        userId: user!.uid,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );
      await _repo.sendMessage(message);
    });
  }
}

final messagesProvider = AsyncNotifierProvider<MessagesViewModel, void>(
  () => MessagesViewModel(),
);

// Note: When listening to web sockets, firebase, or anything that consumes resources,
// it is important to use [StreamProvider.autoDispose] instead of simply [StreamProvider].
// This ensures that the resources are released when no longer needed as, by default,
// a [StreamProvider] is almost never destroyed.
// autoDispose를 해주지 않으면 채팅방을 나가도 StreamProvider를 계속 사용중인 상태가 유지된다.
final chatProvider = StreamProvider.autoDispose<List<MessageModel>>(
  (ref) {
    final db = FirebaseFirestore.instance;

    return db
        .collection("chat_rooms")
        .doc("sfXzKECn7IuWquPXNBNK")
        .collection("texts")
        .orderBy("createdAt")
        .snapshots()
        .map((event) => event.docs
            .map(
              (doc) => MessageModel.fromJson(
                doc.data(),
              ),
            )
            .toList()
            .reversed
            .toList());
  },
);
