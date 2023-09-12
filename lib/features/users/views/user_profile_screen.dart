import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:street_workout/constants/breakpoint.dart';
import 'package:street_workout/constants/gaps.dart';
import 'package:street_workout/constants/sizes.dart';
import 'package:street_workout/features/settings/settings_screen.dart';
import 'package:street_workout/features/users/models/user_profile_model.dart';
import 'package:street_workout/features/users/view_model/users_view_model.dart';
import 'package:street_workout/features/users/views/edit_profile_screen.dart';
import 'package:street_workout/features/users/views/widgets/avatar.dart';
import 'package:street_workout/features/users/views/widgets/persistent_tab_bar.dart';
import 'package:street_workout/features/users/views/widgets/user_action_button.dart';
import 'package:street_workout/features/users/views/widgets/user_count.dart';
import 'package:street_workout/utils.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  final String username;
  final String tab;

  const UserProfileScreen({
    super.key,
    required this.username,
    required this.tab,
  });

  @override
  ConsumerState<UserProfileScreen> createState() => UserProfileScreenState();
}

class UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  final String _placeholder = "assets/images/placeholder_.jpg";
  final String _imageUrl = "https://source.unsplash.com/random/?";

  final double _aspectRatio = 9 / 12;
  final double gridMarkerGap = 5;

  void _onSettingsPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }

  void _onEditProfilePressed(UserProfileModel profileModel) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(profileModel: profileModel),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final isDark = isDarkMode(context);

    return ref.watch(usersProvider).when(
          error: (error, stackTrace) => Center(
            child: Text(error.toString()),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
          data: (data) => Scaffold(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            body: SafeArea(
              child: DefaultTabController(
                initialIndex: widget.tab == 'likes' ? 1 : 0,
                length: 2,
                child: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        title: Text(data.name),
                        centerTitle: true,
                        actions: [
                          IconButton(
                            onPressed: () => _onEditProfilePressed(data),
                            icon: const FaIcon(
                              FontAwesomeIcons.userPen,
                              size: Sizes.size20,
                            ),
                          ),
                          IconButton(
                            onPressed: _onSettingsPressed,
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
                            Avatar(
                              uid: data.uid,
                              name: data.name,
                              hasAvatar: data.hasAvatar,
                            ),
                            Gaps.v14,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "@${data.name}",
                                  style: const TextStyle(
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
                                  const UserCount(
                                      count: "97", countName: "Following"),
                                  VerticalDivider(
                                    width: Sizes.size30,
                                    thickness: Sizes.size1,
                                    color: Colors.grey.shade300,
                                    indent: Sizes.size14,
                                    endIndent: Sizes.size14,
                                  ),
                                  const UserCount(
                                      count: "10M", countName: "Followers"),
                                  VerticalDivider(
                                    width: Sizes.size30,
                                    thickness: Sizes.size1,
                                    color: Colors.grey.shade300,
                                    indent: Sizes.size14,
                                    endIndent: Sizes.size14,
                                  ),
                                  const UserCount(
                                      count: "194.3M", countName: "Likes"),
                                ],
                              ),
                            ),
                            Gaps.v14,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                UserActionButton(
                                  onTap: () {},
                                  width: Sizes.size96 + Sizes.size48,
                                  color: Theme.of(context).primaryColor,
                                  content: const Text(
                                    "Follow",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Gaps.h6,
                                UserActionButton(
                                  width: Sizes.size48,
                                  color: isDark
                                      ? Colors.grey.shade600
                                      : Colors.grey.shade300,
                                  content: const Icon(
                                    FontAwesomeIcons.paperPlane,
                                  ),
                                ),
                                Gaps.h6,
                                UserActionButton(
                                  width: Sizes.size48,
                                  color: isDark
                                      ? Colors.grey.shade600
                                      : Colors.grey.shade300,
                                  content: const Icon(
                                    FontAwesomeIcons.caretDown,
                                  ),
                                ),
                              ],
                            ),
                            Gaps.v14,
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Sizes.size32,
                              ),
                              child: Text(
                                data.bio,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Gaps.v14,
                            if (data.link.isNotEmpty)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const FaIcon(
                                    FontAwesomeIcons.link,
                                    size: Sizes.size12,
                                  ),
                                  Gaps.h4,
                                  Text(
                                    data.link,
                                    style: const TextStyle(
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
                        itemCount: 20,
                        padding: EdgeInsets.zero,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: deviceWidth > Breakpoints.md ? 5 : 3,
                          crossAxisSpacing: Sizes.size2,
                          mainAxisSpacing: Sizes.size2,
                          childAspectRatio: _aspectRatio,
                        ),
                        itemBuilder: (context, index) => Stack(
                          children: [
                            AspectRatio(
                              aspectRatio: _aspectRatio,
                              child: FadeInImage.assetNetwork(
                                placeholderFit: BoxFit.cover,
                                fit: BoxFit.cover,
                                placeholder: _placeholder,
                                image: "$_imageUrl$index",
                              ),
                            ),
                            if (index < 2)
                              Positioned(
                                // top left
                                top: gridMarkerGap,
                                left: gridMarkerGap,
                                child: Container(
                                  padding: const EdgeInsets.all(Sizes.size2),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  child: const Text(
                                    "Pinned",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            if (index == 3)
                              Positioned(
                                top: gridMarkerGap,
                                right: gridMarkerGap,
                                child: const FaIcon(
                                  FontAwesomeIcons.image,
                                  color: Colors.white,
                                  size: Sizes.size16,
                                ),
                              ),
                            Positioned(
                              bottom: gridMarkerGap,
                              left: gridMarkerGap,
                              child: Row(
                                children: [
                                  const FaIcon(
                                    FontAwesomeIcons.play,
                                    color: Colors.white,
                                    size: Sizes.size14,
                                  ),
                                  Gaps.h4,
                                  Text(
                                    '${"${(index + 10) * 100}".substring(0, 3)} ${index % 2 == 1 ? 'M' : 'K'}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
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
            ),
          ),
        );
  }
}
