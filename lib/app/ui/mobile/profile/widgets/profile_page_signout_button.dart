import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/auth/auth_controller.dart';
import '../../../theme/app_color.dart';

class SignOutButton extends GetView<AuthPageController> {
  const SignOutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        child: Text('sign_out'.tr, style: context.textTheme.titleMedium),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(ThemeBasedColor(context, greyColor, greyColor2)),
        ),
        onPressed: controller.signOut,
      ),
    );
  }
}
