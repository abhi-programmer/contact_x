import 'dart:developer';

import 'package:contact_x/services/auth_service.dart';
import 'package:contact_x/utils/my_sharedpreference.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  final RxBool isLoading = false.obs;

  String get displayName => _authService.displayName;

  String get email => _authService.email;

  String get photoUrl => _authService.photoUrl;

  Future<UserCredential?> signInWithGoogle() async {
    try {
      isLoading.value = true;

      final credential = await _authService.signInWithGoogle();

      if (credential != null) {
        await MySharedPreferences.instance.setStringValue(
          "access_token",
          credential.user!.uid,
        );
      }

      return credential;
    } catch (e) {
      log('Google Sign In Error: $e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();

    await MySharedPreferences.instance.removeValue("access_token");
  }

  Future<void> logout() async {
    await signOut();
  }
}
