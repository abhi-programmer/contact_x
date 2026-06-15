import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  void changeTheme(String mode) {
    switch (mode) {
      case 'light':
        themeMode.value = ThemeMode.light;
        Get.changeThemeMode(ThemeMode.light);
        break;

      case 'dark':
        themeMode.value = ThemeMode.dark;
        Get.changeThemeMode(ThemeMode.dark);
        break;

      default:
        themeMode.value = ThemeMode.system;
        Get.changeThemeMode(ThemeMode.system);
    }
  }

  String get selectedTheme {
    switch (themeMode.value) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'auto';
    }
  }
}
