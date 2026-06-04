import 'package:contact_x/controllers/theme_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:contact_x/controllers/auth_controller.dart';
import 'package:contact_x/controllers/contact_controller.dart';
import 'package:contact_x/screens/auth/splash_screen.dart';
import 'package:contact_x/theme/app_color_theme.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SharedPreferences.getInstance();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Get.put(AuthController());
  Get.put(ContactController());
  Get.put(ThemeController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primaryBlue,
      primary: AppColors.primaryBlue,
    );

    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,

        themeMode: Get.find<ThemeController>().themeMode.value,

        theme: ThemeData(
          useMaterial3: true,
          colorScheme: colorScheme,

          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
            ),
          ),

          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: AppColors.primaryBlue,
            foregroundColor: Colors.white,
          ),

          appBarTheme: AppBarTheme(
            centerTitle: true,
            backgroundColor: colorScheme.surface,
            foregroundColor: colorScheme.onSurface,
          ),
        ),

        darkTheme: ThemeData.dark(useMaterial3: true),

        home: const SplashScreen(),
      ),
    );
  }
}
