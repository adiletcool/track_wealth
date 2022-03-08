import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:track_wealth/app/ui/mobile/widgets/sliver_fill_column.dart';

import '../../../controllers/profile/profile_controller.dart';
import 'widgets/profile_page_appbar.dart';
import 'widgets/profile_page_signout_button.dart';

class ProfilePage extends GetView<ProfilePageController> {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
      slivers: [
        ProfilePageAppBar(),
        ProfilePageBody(),
      ],
    );
  }
}

class ProfilePageBody extends StatelessWidget {
  const ProfilePageBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverFillColumn(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(),
        const SignOutButton(),
      ],
    );
  }
}
