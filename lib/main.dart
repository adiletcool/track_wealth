import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:device_preview/device_preview.dart';
import 'package:track_wealth/app/controllers/auth/auth_controller.dart';

import 'app/routes/app_pages.dart';
import 'app/translations/add_translations.dart';
import 'app/ui/theme/app_theme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then((value) => Get.put(AuthController()));

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // Theming
      theme: lightThemeData,
      themeMode: ThemeMode.system,
      darkTheme: darkThemeData,
      // Routing
      home: const Center(child: CircularProgressIndicator()),
      getPages: AppPages.pages,
      defaultTransition: Transition.fade,
      // Localization
      locale: Get.deviceLocale,
      fallbackLocale: const Locale('en', 'US'), // specify the fallback locale in case an invalid locale is selected.
      translationsKeys: AppTranslation.translations,
      // Debugging
      useInheritedMediaQuery: true,
      debugShowCheckedModeBanner: false,
      builder: DevicePreview.appBuilder,
    );
  }
}
