import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:contact_x/app.dart';
import 'package:contact_x/controllers/auth_controller.dart';
import 'package:contact_x/theme/app_images.dart';
import 'package:contact_x/widgets/app_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),

              Hero(
                tag: "app_logo",
                child: Image.asset(AppLogos.logo, width: 120, height: 120),
              ),

              const SizedBox(height: 32),

              Text(
                "Contact X",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                "Your contacts, beautifully organized and always in sync.",
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
              ),

              const SizedBox(height: 40),

              Obx(
                () => AppButton(
                  onPressed: () async {
                    Get.offAll(() => const App());
                  },
                  // onPressed: authController.isLoading.value
                  //     ? null
                  //     : () async {
                  //         try {
                  //           final userCredential = await authController
                  //               .signInWithGoogle();

                  //           if (userCredential == null) {
                  //             Get.snackbar(
                  //               "Login Failed",
                  //               "User credential is null",
                  //               snackPosition: SnackPosition.BOTTOM,
                  //             );
                  //             return;
                  //           }

                  //           await Get.find<ContactController>()
                  //               .reloadContacts();

                  //           Get.offAll(() => const App());
                  //         } catch (e) {
                  //           Get.snackbar(
                  //             "Login Error",
                  //             e.toString(),
                  //             duration: const Duration(seconds: 15),
                  //           );

                  //           debugPrint("LOGIN ERROR: $e");
                  //         }
                  //       },
                  icon: Icons.login,
                  text: "Continue with Google",
                  isLoading: authController.isLoading.value,
                ),
              ),

              const Spacer(),

              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  "By continuing, you agree to our Terms & Privacy Policy.",
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
