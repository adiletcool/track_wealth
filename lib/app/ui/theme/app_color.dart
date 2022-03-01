import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeBasedColor extends Color {
  ThemeBasedColor(
    BuildContext context,
    Color lightThemeColor,
    Color darkThemeColor,
  ) : super(context.isDarkMode ? darkThemeColor.value : lightThemeColor.value);
}

const Color exampleColor = Colors.white;

// Auth method cards
const Color googleBackgroundColor = Color(0xffFF5941);
const Color facebookBackgroundColor = Color(0xff1877F2);
const Color twitterBackgroundColor = Color(0xff00AEED);
const Color emailBackgroundColor = Color(0xff2D9248);
const Color phoneBackgroundColor = Color(0xff9e579d);

const Color greyColor = Color(0xffE2E2E2);
const Color greyColor2 = Color(0xff424242);
const Color darkGreyColor = Color(0xff8a8a8a);
const Color lightGreyColor = Color(0xffF5F5F5);
const Color blueColor = Color(0xFF2A5BDD);
const Color chartVolumeBlueColor = Color(0xff4A87B9);
const Color inactiveButtonColor = Color(0xff574B90);
const Color darkBackgroundColor = Color(0xff161817);

const Color greenBrightColor = Color(0xff00D7A3);
const Color redBrightColor = Color(0xffED386A);

Color transparentGreyColor = Colors.grey.withOpacity(0.15);
