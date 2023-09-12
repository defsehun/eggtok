import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:street_workout/constants/gaps.dart';
import 'package:street_workout/constants/sizes.dart';
import 'package:street_workout/features/videos/view_models/upload_video_view_model.dart';

class UploadVideoScreen extends ConsumerStatefulWidget {
  const UploadVideoScreen({
    super.key,
    required this.video,
  });

  final XFile video;

  @override
  UploadVideoScreenState createState() => UploadVideoScreenState();
}

class UploadVideoScreenState extends ConsumerState<UploadVideoScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {};

  void _onPostTap() {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        ref.read(uploadVideoProvider.notifier).uploadVideo(
              context: context,
              video: File(widget.video.path),
              title: _formData["title"]!,
              description: _formData["desc"]!,
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Post"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.size36),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Gaps.v40,
              TextFormField(
                decoration: const InputDecoration(
                  hintText: "Title",
                ),
                onSaved: (newValue) {
                  _formData["title"] = newValue ?? "";
                },
                maxLength: 50,
              ),
              Gaps.v16,
              TextFormField(
                decoration: const InputDecoration(
                  hintText: "Description",
                ),
                onSaved: (newValue) {
                  _formData["desc"] = newValue ?? "";
                },
                maxLength: 100,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          top: Sizes.size32,
          bottom: Sizes.size64,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 300,
              height: Sizes.size48,
              child: CupertinoButton(
                onPressed: ref.watch(uploadVideoProvider).isLoading
                    ? () {}
                    : _onPostTap,
                color: Theme.of(context).primaryColor,
                child: ref.watch(uploadVideoProvider).isLoading
                    ? const SizedBox(
                        width: 300,
                        height: Sizes.size48,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : const Text("Post"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
