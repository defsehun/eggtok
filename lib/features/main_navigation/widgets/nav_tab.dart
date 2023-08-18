import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:street_workout/constants/gaps.dart';

class NavTab extends StatelessWidget {
  const NavTab({
    super.key,
    required this.text,
    required this.isSelected,
    required this.icon,
    required this.onTap,
    required this.selectedIcon,
    required this.selectIndex,
  });

  final String text;
  final bool isSelected;
  final IconData icon;
  final IconData selectedIcon;
  final Function onTap;
  final int selectIndex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(),
        child: Container(
          color: selectIndex == 0 ? Colors.black : Colors.white,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 100),
            opacity: isSelected ? 1 : 0.3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  isSelected ? selectedIcon : icon,
                  color: selectIndex == 0 ? Colors.white : Colors.black,
                ),
                Gaps.v5,
                Text(
                  text,
                  style: TextStyle(
                    color: selectIndex == 0 ? Colors.white : Colors.black,
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
