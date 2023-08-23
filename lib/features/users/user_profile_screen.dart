import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:street_workout/constants/gaps.dart';
import 'package:street_workout/constants/sizes.dart';
import 'package:street_workout/features/users/widgets/persistent_tab_bar.dart';
import 'package:street_workout/features/users/widgets/user_count.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final String _avatarImageUrl =
      "https://cdn.buymeacoffee.com/uploads/profile_pictures/2023/07/jgSw6oRTsa7Ak5CM.jpeg@300w_0e.webp";

  final String _thumImageUrl =
      "https://nebbia.fitness/vendors/phpThumb/phpThumb.php?w=490&h=740&sia=dvojvrstvova_sportova_podprsenka_flex_241_blue_005.jpg&src=/uploads/47/products/780/dvojvrstvova_sportova_podprsenka_flex_241_blue_005.jpg&far=1";

  final double _aspectRatio = 9 / 12;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                title: const Text("Sans"),
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: const FaIcon(
                      FontAwesomeIcons.gear,
                      size: Sizes.size20,
                    ),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      foregroundColor: Colors.teal,
                      foregroundImage: NetworkImage(_avatarImageUrl),
                      child: const Text("S"),
                    ),
                    Gaps.v14,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "@mikusova",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Sizes.size18,
                          ),
                        ),
                        Gaps.h5,
                        FaIcon(
                          FontAwesomeIcons.solidCircleCheck,
                          size: Sizes.size16,
                          color: Colors.blue.shade500,
                        ),
                      ],
                    ),
                    Gaps.v14,
                    SizedBox(
                      height: Sizes.size48,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const UserCount(count: "97", countName: "Following"),
                          VerticalDivider(
                            width: Sizes.size30,
                            thickness: Sizes.size1,
                            color: Colors.grey.shade300,
                            indent: Sizes.size14,
                            endIndent: Sizes.size14,
                          ),
                          const UserCount(count: "10M", countName: "Followers"),
                          VerticalDivider(
                            width: Sizes.size30,
                            thickness: Sizes.size1,
                            color: Colors.grey.shade300,
                            indent: Sizes.size14,
                            endIndent: Sizes.size14,
                          ),
                          const UserCount(count: "194.3M", countName: "Likes"),
                        ],
                      ),
                    ),
                    Gaps.v14,
                    FractionallySizedBox(
                      widthFactor: 0.33,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: Sizes.size10,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(
                              Sizes.size4,
                            ),
                          ),
                        ),
                        child: const Text(
                          "Follow",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Gaps.v14,
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Sizes.size32,
                      ),
                      child: Text(
                        "All highlights and where to watch live matches on FIFA+ I wonder how it would loook",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Gaps.v14,
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.link,
                          size: Sizes.size12,
                        ),
                        Gaps.h4,
                        Text(
                          "https://www.instagram.com/nebbia_fitness/",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Gaps.v14,
                  ],
                ),
              ),
              SliverPersistentHeader(
                delegate: PersistentTabBar(),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            children: [
              GridView.builder(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                itemCount: 20,
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: Sizes.size2,
                  mainAxisSpacing: Sizes.size2,
                  childAspectRatio: _aspectRatio,
                ),
                itemBuilder: (context, index) => Column(
                  children: [
                    AspectRatio(
                      aspectRatio: _aspectRatio,
                      child: FadeInImage.assetNetwork(
                        placeholderFit: BoxFit.cover,
                        fit: BoxFit.cover,
                        placeholder: "assets/images/placeholder.jpg",
                        image: _thumImageUrl,
                      ),
                    ),
                  ],
                ),
              ),
              const Center(
                child: Text("page one"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
