import 'package:flutter/material.dart';
import 'package:street_workout/constants/gaps.dart';
import 'package:street_workout/constants/sizes.dart';

class UserCount extends StatelessWidget {
  const UserCount({super.key, required this.count, required this.countName});

  final String count;
  final String countName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: Sizes.size18,
            height: 1,
          ),
        ),
        Gaps.v3,
        Text(
          countName,
          style: TextStyle(
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }
}
