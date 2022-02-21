import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/profile/profile_controller.dart';
import 'widgets/profile_page_appbar.dart';
import 'widgets/profile_page_body.dart';

class ProfilePage extends GetView<ProfileController> {
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
