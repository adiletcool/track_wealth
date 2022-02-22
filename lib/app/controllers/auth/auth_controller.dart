import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/get.dart';

import '../../constants/firebase_constants.dart';
import '../../data/enums/auth.dart';
import '../../routes/app_pages.dart';
import '../../ui/theme/app_color.dart';

class AuthMethodConfig {
  final AuthMethod method;
  final Color backgroundColor;
  final void Function()? onTap;

  AuthMethodConfig(this.method, this.backgroundColor, this.onTap);
}

class AuthController extends GetxController {
  late Rx<User?> _user;

  @override
  void onReady() {
    _user = auth.currentUser.obs;
    _user.bindStream(auth.userChanges());

    ever(_user, _initialScreen);
    super.onReady();
  }

  _initialScreen(User? user) {
    if (user != null) {
      return Get.offAllNamed(Routes.initial);
    }
    if (Get.currentRoute != Routes.auth) {
      return Get.offAllNamed(Routes.auth);
    }
  }

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
  void authViaEmail() => email.authenticate(isLogin: isLogin.value);

  // Auth via phone
  PhoneAuthController phone = PhoneAuthController();
  void authViaPhone() => phone.authenticate();

  // Login via socials
  void loginViaSocial(AuthMethod method) {}

  void signOut() {
    try {
      auth.signOut();
    } on FirebaseAuthException catch (e) {
      Get.showSnackbar(GetSnackBar(
        message: e.code.tr,
        duration: 5.seconds,
        snackPosition: SnackPosition.TOP,
        title: 'auth_error'.tr,
      ));
    }
  }
}

class EmailAuthController {
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;

  Rx<FocusNode> emailFocusNode = FocusNode().obs;
  Rx<FocusNode> passwordFocusNode = FocusNode().obs;

  String get email => emailController.value.text;
  String get password => passwordController.value.text;

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
    if (email.isEmail && password.length >= 6) {
      canAuthViaEmail.value = true;
      return;
    }
    canAuthViaEmail.value = false;
  }

  void authenticate({required bool isLogin}) async {
    if (!canAuthViaEmail.value) return;
    try {
      if (isLogin) {
        await auth.signInWithEmailAndPassword(email: email, password: password);
      } else {
        await auth.createUserWithEmailAndPassword(email: email, password: password);
      }

      emailController.value.clear();
      passwordController.value.clear();
    } on FirebaseAuthException catch (e) {
      Get.showSnackbar(GetSnackBar(
        message: e.code.tr,
        duration: 5.seconds,
        snackPosition: SnackPosition.TOP,
        title: 'auth_error'.tr,
      ));
    } catch (e) {
      Get.showSnackbar(GetSnackBar(
        message: e.toString(),
        duration: 5.seconds,
        snackPosition: SnackPosition.TOP,
      ));
    }
  }
}

class PhoneAuthController {
  // Auth via phone
  Rx<MaskedTextController> phoneNumberController = MaskedTextController(mask: '+7 (000) 000-00-00').obs;
  Rx<TextEditingController> phoneCodeController = TextEditingController().obs;

  Rx<FocusNode> phoneNumberFocusNode = FocusNode().obs;
  Rx<FocusNode> phoneCodeFocusNode = FocusNode().obs;

  String get phoneNumber => phoneNumberController.value.text;
  String get phoneCode => phoneCodeController.value.text;

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
    Get.showSnackbar(GetSnackBar(message: 'SENT PHONE CODE', duration: 3.seconds));
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
  }
}
