import 'package:flutter/material.dart';
import 'package:karim_taha_task/core/colors.dart';

class HomeScreenHeader extends StatelessWidget {
  const HomeScreenHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome Back,',
          style: TextStyle(
            fontSize: 18,
            color: MainColors.gray,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          'Karim Taha',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: MainColors.black,
          ),
        ),
      ],
    );
  }
}
