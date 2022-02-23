import 'package:get/get.dart';

void showDefaultSnackbar({
  String? message,
  Duration? duration = const Duration(seconds: 5),
  SnackPosition snackPosition = SnackPosition.TOP,
  String? title,
}) {
  Get.closeCurrentSnackbar().then(
    (_) => Get.showSnackbar(GetSnackBar(
      message: message,
      duration: duration,
      snackPosition: snackPosition,
      title: title,
    )),
  );
}
