import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/auth/auth_controller.dart';
import '../../../theme/app_color.dart';
import '../../widgets/expanded_section.dart';
import 'auth_method_switcher.dart';

class EmailAuthBody extends GetView<AuthController> {
  const EmailAuthBody({
    Key? key,
    required this.keyboardVisible,
  }) : super(key: key);

  final bool keyboardVisible;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            const EmailAuthInputFields(),
            const SizedBox(height: 10),
            Obx(() => ExpandedSection(
                  expand: controller.isLogin.value,
                  child: ForgotPasswordButton(),
                )),
            const SizedBox(height: 10),
            AuthMethodSwitcher(height: 40),
          ],
        ),
        AnimatedPadding(
          padding: EdgeInsets.only(bottom: context.mediaQueryViewInsets.bottom + 20),
          duration: 300.milliseconds,
          child: ExpandedSection(
            axisAlignment: -1.0,
            expand: keyboardVisible || controller.email.canAuthViaEmail.value,
            child: const Center(child: EmailAuthButton()),
          ),
        ),
      ],
    );
  }
}

class ForgotPasswordButton extends StatelessWidget {
  ForgotPasswordButton({Key? key}) : super(key: key);
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: context.width,
      child: TextButton(
        onPressed: () {},
        child: Text(
          'forgot_password'.tr,
          style: context.textTheme.caption?.copyWith(fontSize: 15, decoration: TextDecoration.underline),
        ),
      ),
    );
  }
}

class AuthMethodTitle extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();

  AuthMethodTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Obx(() {
        String _authTitle = authController.isLogin.value ? 'login'.tr : 'register'.tr;

        return AnimatedSwitcher(
          duration: 200.milliseconds,
          transitionBuilder: (Widget child, Animation<double> animation) => SizeTransition(
            child: child,
            sizeFactor: animation,
            axisAlignment: authController.isLogin.value ? -1.0 : 1.0,
          ),
          child: Center(
            key: ValueKey<String>(_authTitle),
            child: Text(
              _authTitle,
              textAlign: TextAlign.center,
              style: context.textTheme.headlineMedium,
            ),
          ),
        );
      }),
    );
  }
}

class EmailAuthInputFields extends GetView<AuthController> {
  const EmailAuthInputFields({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color borderColor = (context.isDarkMode ? lightGreyColor : Colors.black).withOpacity(.3);

    return Container(
      height: 150,
      width: context.width - 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          EmailAuthTextField(
            textController: controller.email.emailController.value,
            labelText: 'email'.tr,
          ),
          Divider(color: borderColor, thickness: 1, height: 1),
          Obx(() => EmailAuthTextField(
                textController: controller.email.passwordController.value,
                labelText: 'password'.tr,
                isPassword: true,
              )),
        ],
      ),
    );
  }
}

// TODO: remove splash
class EmailAuthButton extends GetView<AuthController> {
  const EmailAuthButton({Key? key}) : super(key: key);
  // TODO: Text switches into progress indicator when pressed login / register. If success -> changeRoute, otherwise -> textfield error decorariton

  @override
  Widget build(BuildContext context) {
    return Obx(() => InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: AnimatedContainer(
            duration: 300.milliseconds,
            height: 50,
            width: context.width - 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: controller.email.canAuthViaEmail.value ? blueColor : inactiveButtonColor,
            ),
            child: Center(
              child: Text(
                controller.isLogin.value ? 'to_login'.tr : 'to_register'.tr,
                style: TextStyle(fontSize: 22, color: controller.email.canAuthViaEmail.value ? Colors.white : Colors.grey),
              ),
            ),
          ),
          onTap: () => controller.authViaEmail(),
        ));
  }
}

class EmailAuthTextField extends GetView<AuthController> {
  final TextEditingController textController;
  final String labelText;
  final bool isPassword;

  const EmailAuthTextField({
    Key? key,
    required this.textController,
    required this.labelText,
    this.isPassword = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Center(
        child: Obx(() => TextField(
              focusNode: isPassword ? controller.email.passwordFocusNode.value : controller.email.emailFocusNode.value,
              maxLines: 1,
              autocorrect: false,
              controller: textController,
              textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.center,
              style: const TextStyle(fontSize: 25),
              keyboardType: isPassword ? null : TextInputType.emailAddress,
              obscureText: isPassword ? !controller.email.showPassword.value : false,
              onChanged: (_) {
                controller.email.validateEmailAndPassword();
                controller.email.updateEmailAndPasswordControllers();
              },
              onSubmitted: (value) => isPassword ? null : controller.email.passwordFocusNode.value.requestFocus(),
              decoration: InputDecoration(
                hintText: labelText,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                counterText: '',
                suffixIcon: (isPassword && textController.text != '')
                    ? IconButton(
                        icon: Icon(
                          controller.email.showPassword.value ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                          color: darkGreyColor,
                        ),
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onPressed: controller.email.toggleShowPassword,
                      )
                    : null,
              ),
            )),
      ),
    );
  }
}
