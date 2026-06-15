import 'package:contact_x/app/theme/theme_controller.dart';
import 'package:contact_x/features/contacts/presentation/bindings/contact_binding.dart';
import 'package:contact_x/app/splash_screen.dart';
import 'package:contact_x/core/constants/app_color_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  /// Feature Bindings
  ContactBinding().dependencies();

  /// Global Controllers
  Get.put(ThemeController(), permanent: true);

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

        title: "ContactX",

        themeMode: Get.find<ThemeController>().themeMode.value,

        theme: ThemeData(
          useMaterial3: true,

          colorScheme: colorScheme,

          appBarTheme: AppBarTheme(
            centerTitle: true,
            backgroundColor: colorScheme.surface,
            foregroundColor: colorScheme.onSurface,
          ),

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

          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),

        darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark),

        home: const SplashScreen(),
      ),
    );
  }
}
