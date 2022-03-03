import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/auth/auth_controller.dart';

class AuthMethodSwitcher extends StatelessWidget {
  final double height;
  final TextStyle? style;
  final Color? backgroundColor;
  AuthMethodSwitcher({Key? key, this.height = 50, this.style, this.backgroundColor}) : super(key: key);

  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      height: height,
      width: context.width,
      child: TextButton(
        child: Obx(
          () {
            String _switchMethodTitle = authController.isLogin.value ? 'to_register'.tr : 'to_login'.tr;

            return AnimatedSwitcher(
              duration: 200.milliseconds,
              child: Text(
                _switchMethodTitle,
                key: ValueKey<String>(_switchMethodTitle),
                style: context.textTheme.caption?.copyWith(fontSize: 15, decoration: TextDecoration.underline),
              ),
            );
          },
        ),
        onPressed: authController.switchAuthMethod,
      ),
    );
  }
}
