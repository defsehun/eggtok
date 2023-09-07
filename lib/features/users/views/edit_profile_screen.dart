import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:street_workout/constants/gaps.dart';
import 'package:street_workout/constants/sizes.dart';
import 'package:street_workout/features/users/models/user_profile_model.dart';
import 'package:street_workout/features/users/view_model/users_view_model.dart';
import 'package:street_workout/utils.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final UserProfileModel profileModel;

  const EditProfileScreen({super.key, required this.profileModel});

  @override
  ConsumerState<EditProfileScreen> createState() => EditProfileScreenState();
}

class EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {};
  bool _isDisable = true;

  void _onSaveTap() {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        ref.read(usersProvider.notifier).updateProfile(
              name: _formData["name"],
              bio: _formData["bio"],
              link: _formData["link"],
            );

        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Edit profile"),
        centerTitle: true,
        leadingWidth: 90,
        leading: Center(
          child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancle")),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.size20),
            child: GestureDetector(
              onTap: _isDisable ? null : _onSaveTap,
              child: Text(
                "Save",
                style: TextStyle(
                  color: _isDisable
                      ? isDarkMode(context)
                          ? Colors.grey.shade900
                          : Colors.grey.shade300
                      : Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.size36,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Gaps.v28,
              TextFormField(
                initialValue: widget.profileModel.name,
                maxLength: 10,
                decoration: const InputDecoration(
                  hintText: "Name",
                ),
                onChanged: (newValue) {
                  setState(() {
                    _isDisable = false;
                  });
                },
                onSaved: (newValue) {
                  if (newValue != null && newValue.isNotEmpty) {
                    _formData['name'] = newValue;
                  }
                },
              ),
              Gaps.v16,
              TextFormField(
                initialValue: widget.profileModel.bio,
                maxLength: 100,
                decoration: const InputDecoration(
                  hintText: "Bio",
                ),
                onChanged: (newValue) {
                  setState(() {
                    _isDisable = false;
                  });
                },
                onSaved: (newValue) {
                  if (newValue != null) {
                    _formData['bio'] = newValue;
                  }
                },
              ),
              Gaps.v16,
              TextFormField(
                initialValue: widget.profileModel.link,
                maxLength: 60,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  hintText: "Link",
                ),
                onChanged: (newValue) {
                  setState(() {
                    _isDisable = false;
                  });
                },
                onSaved: (newValue) {
                  if (newValue != null) {
                    _formData['link'] = newValue;
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
