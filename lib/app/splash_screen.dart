import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:contact_x/app/app.dart';
import 'package:contact_x/core/constants/app_images.dart';
import 'package:contact_x/core/constants/app_color_theme.dart';
import 'package:contact_x/features/contacts/presentation/controllers/contact_controller.dart';

enum PermissionState {
  checking,
  denied,
  permanentlyDenied,
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  PermissionState _permissionState = PermissionState.checking;

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
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _controller.forward();

    Future.delayed(
      const Duration(seconds: 2),
      _checkPermissionAndProceed,
    );
  }

  Future<void> _checkPermissionAndProceed() async {
    if (!mounted) return;

    setState(() {
      _permissionState = PermissionState.checking;
    });

    try {
      final contactController = Get.find<ContactController>();

      
      await contactController.initializeContacts();

      if (!mounted) return;

      if (contactController.hasPermission.value) {
        await _redirect();
      } else {
        final message = contactController.permissionMessage.value.toLowerCase();

        setState(() {
          if (message.contains('permanently')) {
            _permissionState = PermissionState.permanentlyDenied;
          } else {
            _permissionState = PermissionState.denied;
          }
        });
      }
    } catch (e) {
      debugPrint('Permission / contact sync error: $e');

      if (!mounted) return;
      setState(() {
        _permissionState = PermissionState.denied;
      });
    }
  }

  Future<void> _retryPermission() async {
    if (!mounted) return;

    setState(() {
      _permissionState = PermissionState.checking;
    });

    try {
      final contactController = Get.find<ContactController>();

      await contactController.retryPermission();

      if (!mounted) return;

      if (contactController.hasPermission.value) {
        await _redirect();
      } else {
        final message = contactController.permissionMessage.value.toLowerCase();

        setState(() {
          if (message.contains('permanently')) {
            _permissionState = PermissionState.permanentlyDenied;
          } else {
            _permissionState = PermissionState.denied;
          }
        });
      }
    } catch (e) {
      debugPrint('Retry permission error: $e');

      if (!mounted) return;
      setState(() {
        _permissionState = PermissionState.denied;
      });
    }
  }

  Future<void> _redirect() async {
    if (!mounted) return;

    Get.offAll(
      () => const App(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getDescription() {
    switch (_permissionState) {
      case PermissionState.denied:
        return "ContactX needs access to your contacts to list and display them on your dashboard. Please grant access to continue.";

      case PermissionState.permanentlyDenied:
        return "Contacts permission was permanently denied. Please enable it from your device settings and then try again.";

      case PermissionState.checking:
        return "";
    }
  }

  String _getPrimaryButtonText() {
    switch (_permissionState) {
      case PermissionState.denied:
        return "Grant Permission";

      case PermissionState.permanentlyDenied:
        return "Check Again";

      case PermissionState.checking:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: _permissionState == PermissionState.checking
              ? Center(
                  key: const ValueKey('checking'),
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Hero(
                      tag: "app_logo",
                      child: Image.asset(
                        AppLogos.logo,
                        width: 151,
                        height: 151,
                      ),
                    ),
                  ),
                )
              : Center(
                  key: ValueKey(_permissionState),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue.withOpacity(0.08),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.contact_phone_outlined,
                            size: 80,
                            color: AppColors.primaryBlue,
                          ),
                        ),

                        const SizedBox(height: 32),

                        Text(
                          "Contact Access Required",
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),

                        const SizedBox(height: 16),

                        Text(
                          _getDescription(),
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 40),

                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            onPressed: _retryPermission,
                            child: Text(
                              _getPrimaryButtonText(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        if (_permissionState ==
                            PermissionState.permanentlyDenied) ...[
                          const SizedBox(height: 16),

                          Text(
                            "If you already enabled permission from settings, tap “Check Again”.",
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.65),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}