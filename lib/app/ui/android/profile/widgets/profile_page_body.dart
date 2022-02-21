import 'package:flutter/material.dart';

import 'profile_page_signout_button.dart';

class ProfilePageBody extends StatelessWidget {
  const ProfilePageBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(),
          const SignOutButton(),
        ],
      ),
    );
  }
}
