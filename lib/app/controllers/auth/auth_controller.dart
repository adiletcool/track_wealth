import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/get.dart';

import '../../data/enums/auth.dart';
import '../../ui/theme/app_color.dart';

class AuthMethodConfig {
  final AuthMethod method;
  final Color backgroundColor;
  final void Function()? onTap;

  AuthMethodConfig(this.method, this.backgroundColor, this.onTap);
}

class AuthController extends GetxController {
  final List<AuthMethodConfig> standardAuthConfigs = [
    AuthMethodConfig(AuthMethod.google, googleBackgroundColor, () {}),
    AuthMethodConfig(AuthMethod.facebook, facebookBackgroundColor, () {}),
    AuthMethodConfig(AuthMethod.twitter, twitterBackgroundColor, () {}),
  ];

  List<AuthMethodConfig> getAuthConfigs() {
    return [
      ...standardAuthConfigs,
      isEmailChosen.value
          ? AuthMethodConfig(
              AuthMethod.phone,
              phoneBackgroundColor,
              switchEmailChosen,
            )
          : AuthMethodConfig(
              AuthMethod.email,
              emailBackgroundColor,
              switchEmailChosen,
            )
    ];
  }

  // Email / Phone auth can be visible on auth page
  RxBool isEmailChosen = true.obs;
  void switchEmailChosen() => isEmailChosen.toggle();

  // Login / Register state
  RxBool isLogin = true.obs;
  void switchAuthMethod() => isLogin.toggle();

  // Auth via email
  EmailAuthController email = EmailAuthController();
  void authViaEmail() {
    email.authenticate(isLogin: isLogin.value);
    // ...
  }

  // Auth via phone
  PhoneAuthController phone = PhoneAuthController();
  void authViaPhone() {
    phone.authenticate();
    // ...
  }

  // Login via socials
  void loginViaSocial(AuthMethod method) {}
}

class EmailAuthController {
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;
  Rx<FocusNode> emailFocusNode = FocusNode().obs;
  Rx<FocusNode> passwordFocusNode = FocusNode().obs;

  RxBool showPassword = false.obs;
  void toggleShowPassword() => showPassword.toggle();

  RxBool canAuthViaEmail = false.obs; // valid email and typed password

  void updateEmailAndPasswordControllers() {
    // updates with when user changes textfield
    emailController.update((val) {});
    passwordController.update((val) {});
  }

  void validateEmailAndPassword() {
    // updates with when user changes textfield
    if (emailController.value.text.isEmail && passwordController.value.text.length >= 6) {
      canAuthViaEmail.value = true;
      return;
    }
    canAuthViaEmail.value = false;
  }

  Future<void> authenticate({required bool isLogin}) async {
    if (!canAuthViaEmail.value) return;
    // TODO
    if (isLogin) {
      Get.showSnackbar(GetSnackBar(message: 'LOGIN VIA EMAIL', duration: 3.seconds));
    } else {
      Get.showSnackbar(GetSnackBar(message: 'REGISTER VIA EMAIL', duration: 3.seconds));
    }
    Get.offNamed('/market');
  }
}

class PhoneAuthController {
  // Auth via phone
  Rx<MaskedTextController> phoneNumberController = MaskedTextController(mask: '+7 (000) 000-00-00').obs;
  Rx<FocusNode> phoneNumberFocusNode = FocusNode().obs;

  Rx<TextEditingController> phoneCodeController = TextEditingController().obs;
  Rx<FocusNode> phoneCodeFocusNode = FocusNode().obs;

  RxBool phoneNumberValid = false.obs; // whether phone number valid (11 digits)
  RxBool phoneCodeValid = false.obs; // whether phone code valid (6 digits)
  RxBool isPhoneCodeSent = false.obs; // is confirmation code sent via sms
  RxBool canSendPhoneCodeAgain = false.obs; // if code has been sent, next try can be made after some time
  RxInt sendPhoneCodeAgainSecondsLeft = 0.obs;
  RxBool phoneCodeError = false.obs; // whether user typed correct phone code

  void phoneCodeCorrect() => phoneCodeError.value = true; // if phone code is valid and correct
  void phoneCodeIncorrect() => phoneCodeError.value = false; // if phone code is valid and incorrect

  void updatePhoneController() => phoneNumberController.update((val) {});
  void updatePhoneCodeController() => phoneNumberController.update((val) {});

  void validatePhone() {
    if (phoneNumberController.value.text.replaceAll(RegExp(r'[^0-9]'), '').length == 11) {
      phoneNumberValid.value = true;
      return;
    }
    phoneNumberValid.value = false;
  }

  void validatePhoneCode() {
    if (phoneCodeController.value.text.length == 6) {
      phoneCodeValid.value = true;
      return;
    }
    phoneCodeValid.value = false;
  }

  Future<void> changePhoneNumber() async {
    phoneNumberController.value.text = '';
    phoneNumberValid.value = false;
    phoneCodeController.value.text = '';
    phoneCodeValid.value = false;
    isPhoneCodeSent.value = false;
    await Future.delayed(200.milliseconds).then((value) => phoneNumberFocusNode.value.requestFocus());
  }

  void sendPhoneCode() {
    // Start timer
    isPhoneCodeSent.value = true;
    phoneCodeFocusNode.value.requestFocus();
    Get.showSnackbar(GetSnackBar(message: 'SENT PHONE CODE', duration: 3.seconds)); // TODO
  }

  void authenticate() {
    if (!phoneNumberValid.value) {
      return phoneNumberFocusNode.value.requestFocus();
    }

    if (!isPhoneCodeSent.value) {
      return sendPhoneCode();
    }

    if (!phoneCodeValid.value) {
      return phoneCodeFocusNode.value.requestFocus();
    }

    // AUTH TODO
    Get.showSnackbar(GetSnackBar(message: 'AUTH VIA PHONE NUMBER', duration: 3.seconds));
    Get.offNamed('/market');
  }
}
