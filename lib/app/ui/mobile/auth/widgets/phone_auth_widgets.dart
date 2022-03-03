import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pinput/pin_put/pin_put.dart';

import '../../../../controllers/auth/auth_controller.dart';
import '../../../theme/app_color.dart';
import '../../widgets/decorations.dart';
import '../../widgets/expanded_section.dart';
import 'auth_method_switcher.dart';

class PhoneAuthBody extends GetView<AuthController> {
  const PhoneAuthBody({
    Key? key,
    required this.keyboardVisible,
  }) : super(key: key);

  final bool keyboardVisible;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const PhoneAuthTextField(),
              const SizedBox(height: 30),
              ExpandedSection(
                expand: !controller.phone.isPhoneCodeSent.value,
                child: AuthMethodSwitcher(height: 40),
              ),
              const SizedBox(height: 20),
              ExpandedSection(
                expand: controller.phone.phoneNumberValid.value && controller.phone.isPhoneCodeSent.value,
                child: Column(
                  children: [
                    const PhoneCodeTextField(),
                    ChangePhoneSendAgainButtons(),
                  ],
                ),
              ),
            ],
          ),
          AnimatedPadding(
            padding: EdgeInsets.only(bottom: context.mediaQueryViewInsets.bottom + 20),
            duration: 300.milliseconds,
            child: const SendOrConfirmCodeButton(),
          ),
        ],
      );
    });
  }
}

class PhoneAuthTextField extends GetView<AuthController> {
  const PhoneAuthTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: context.width - 30,
        child: Obx(
          () => TextFormField(
            focusNode: controller.phone.phoneNumberFocusNode.value,
            controller: controller.phone.phoneNumberController.value,
            style: const TextStyle(fontSize: 22),
            textAlign: controller.phone.isPhoneCodeSent.value ? TextAlign.center : TextAlign.start,
            decoration: myInputDecoration.copyWith(
              disabledBorder: InputBorder.none,
              counterText: '',
              hintText: '+7 (999) 999-99-99',
            ),
            keyboardType: TextInputType.number,
            enabled: !controller.phone.isPhoneCodeSent.value,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (_) {
              controller.phone.validatePhone();
              controller.phone.updatePhoneController();
            },
          ),
        ));
  }
}

class PhoneCodeTextField extends GetView<AuthController> {
  const PhoneCodeTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
      child: PinPut(
        onTap: controller.phone.phoneCodeValid,
        focusNode: controller.phone.phoneCodeFocusNode.value,
        controller: controller.phone.phoneCodeController.value,
        fieldsCount: 6,
        followingFieldDecoration: eachFieldDecoration,
        selectedFieldDecoration: eachFieldDecoration,
        submittedFieldDecoration: eachFieldDecoration,
        textStyle: const TextStyle(fontSize: 22),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (_) {
          controller.phone.validatePhoneCode();
          controller.phone.updatePhoneCodeController();
        },
      ),
    );
  }
}

class ChangePhoneSendAgainButtons extends StatelessWidget {
  ChangePhoneSendAgainButtons({Key? key}) : super(key: key);
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          child: Text('change_phone_number'.tr, style: const TextStyle(color: blueColor)),
          onPressed: authController.phone.changePhoneNumber,
        ),
        TextButton(
          child: Obx(() => Text(
                authController.phone.canSendPhoneCodeAgain.value
                    ? 'send_again'.tr
                    : 'send_again'.tr + ': ${authController.phone.sendPhoneCodeAgainSecondsLeft.value}',
                style: TextStyle(color: authController.phone.canSendPhoneCodeAgain.value ? blueColor : Colors.grey),
              )),
          onPressed: authController.phone.canSendPhoneCodeAgain.value ? authController.phone.sendPhoneCode : null,
        ),
      ],
    );
  }
}

class SendOrConfirmCodeButton extends GetView<AuthController> {
  const SendOrConfirmCodeButton({Key? key}) : super(key: key);

  Color getButtonColor(phoneNumberValid, isPhoneCodeSent, phoneCodeValid) {
    if (!phoneNumberValid) return inactiveButtonColor;
    if (!isPhoneCodeSent) return blueColor;
    if (!phoneCodeValid) return inactiveButtonColor;
    return blueColor;
  }

  Color getTextColor(phoneNumberValid, isPhoneCodeSent, phoneCodeValid) {
    if (!phoneNumberValid) return Colors.grey;
    if (!isPhoneCodeSent) return Colors.white;
    if (!phoneCodeValid) return Colors.grey;
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Obx(() => AnimatedContainer(
            duration: 300.milliseconds,
            height: 50,
            width: context.width - 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: getButtonColor(
                controller.phone.phoneNumberValid.value,
                controller.phone.isPhoneCodeSent.value,
                controller.phone.phoneCodeValid.value,
              ),
            ),
            child: Center(
              child: Text(
                !controller.phone.isPhoneCodeSent.value ? 'receive_phone_code'.tr : 'confirm'.tr,
                style: TextStyle(
                    fontSize: 22,
                    color: getTextColor(
                      controller.phone.phoneNumberValid.value,
                      controller.phone.isPhoneCodeSent.value,
                      controller.phone.phoneCodeValid.value,
                    )),
              ),
            ),
          )),
      onTap: controller.authViaPhone,
    );
  }
}
