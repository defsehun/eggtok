import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:street_workout/constants/gaps.dart';
import 'package:street_workout/constants/sizes.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: const SafeArea(
          child: TabBarView(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Sizes.size24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gaps.v52,
                    Text(
                      "Watch cool videos!",
                      style: TextStyle(
                        fontSize: Sizes.size36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gaps.v20,
                    Text(
                      "Videos are personalized for you based on what you watch, like, and share.",
                      style: TextStyle(
                        fontSize: Sizes.size18,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Sizes.size24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gaps.v52,
                    Text(
                      "Follow the rules!",
                      style: TextStyle(
                        fontSize: Sizes.size36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gaps.v20,
                    Text(
                      "Videos are personalized for you based on what you watch, like, and share.",
                      style: TextStyle(
                        fontSize: Sizes.size18,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Sizes.size24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gaps.v52,
                    Text(
                      "Enjoy the ride!",
                      style: TextStyle(
                        fontSize: Sizes.size36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gaps.v20,
                    Text(
                      "Videos are personalized for you based on what you watch, like, and share.",
                      style: TextStyle(
                        fontSize: Sizes.size18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: Sizes.size20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const TabPageSelector(
                  selectedColor: Colors.black38,
                ),
                Gaps.v20,
                CupertinoButton(
                  onPressed: () {},
                  color: Theme.of(context).primaryColor,
                  child: const Text("Enter the app!"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
