import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:street_workout/constants/gaps.dart';
import 'package:street_workout/constants/sizes.dart';
import 'package:street_workout/features/users/view_model/users_view_model.dart';
import 'package:street_workout/utils.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

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
        ref.read(usersProvider.notifier).updateProfile();
        // context.goNamed(InterestsScreen.routeName);
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
          child: Column(
            children: [
              Gaps.v28,
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Name",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
                onChanged: (newValue) {
                  setState(() {
                    _isDisable = false;
                  });
                },
                onSaved: (newValue) {
                  if (newValue != null && newValue.isEmpty) {
                    _formData['name'] = newValue;
                  }
                },
              ),
              Gaps.v16,
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Bio",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
                onChanged: (newValue) {
                  setState(() {
                    _isDisable = false;
                  });
                },
                onSaved: (newValue) {
                  print(newValue);
                  if (newValue != null && newValue.isEmpty) {
                    _formData['bio'] = newValue;
                  }
                },
              ),
              Gaps.v16,
              TextFormField(
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  hintText: "Link",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
                onChanged: (newValue) {
                  setState(() {
                    _isDisable = false;
                  });
                },
                onSaved: (newValue) {
                  print(newValue);
                  if (newValue != null && newValue.isEmpty) {
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
