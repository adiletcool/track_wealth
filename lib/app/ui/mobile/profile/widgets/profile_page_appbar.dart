import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePageAppBar extends StatelessWidget {
  const ProfilePageAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text('profile'.tr),
      elevation: 0,
      centerTitle: true,
    );
  }
}
