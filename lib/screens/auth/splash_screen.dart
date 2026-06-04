import 'package:flutter/material.dart';

import 'package:contact_x/app.dart';
import 'package:contact_x/theme/app_images.dart';
import 'package:contact_x/utils/my_sharedpreference.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();

    Future.delayed(const Duration(seconds: 2), () {
      redirect();
    });
  }

  Future<void> redirect() async {
    final token = await MySharedPreferences.instance.getStringValue(
      "access_token",
    );

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const App(),
        // builder: (_) => token == null ? const LoginScreen() : const App(),
      ),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Hero(
            tag: "app_logo",
            child: Image.asset(AppLogos.logo, width: 151, height: 151),
          ),
        ),
      ),
    );
  }
}
