import 'package:contact_x/controllers/contact_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:contact_x/controllers/auth_controller.dart';
import 'package:contact_x/screens/auth/login_screen.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final names = authController.displayName.trim().split(' ');

    final firstName = names.isNotEmpty ? names.first : '';

    final lastName = names.length > 1 ? names.sublist(1).join(' ') : '';

    return Scaffold(
      appBar: AppBar(title: const Text("My Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 55,
              backgroundColor: colorScheme.surfaceContainerHighest,
              backgroundImage: authController.photoUrl.isNotEmpty
                  ? NetworkImage(authController.photoUrl)
                  : null,
              child: authController.photoUrl.isEmpty
                  ? Text(
                      authController.displayName.isNotEmpty
                          ? authController.displayName[0].toUpperCase()
                          : "?",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),

            const SizedBox(height: 16),

            Text(
              authController.displayName,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 28),

            Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    if (firstName.isNotEmpty) ...[
                      _ProfileTile(
                        icon: Icons.person_outline,
                        title: "First Name",
                        value: firstName,
                      ),
                    ],

                    if (firstName.isNotEmpty &&
                        (lastName.isNotEmpty ||
                            authController.email.isNotEmpty))
                      const Divider(),

                    if (lastName.isNotEmpty) ...[
                      _ProfileTile(
                        icon: Icons.person_outline,
                        title: "Last Name",
                        value: lastName,
                      ),
                    ],

                    if (lastName.isNotEmpty && authController.email.isNotEmpty)
                      const Divider(),

                    if (authController.email.isNotEmpty)
                      _ProfileTile(
                        icon: Icons.email_outlined,
                        title: "Email",
                        value: authController.email,
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            TextButton.icon(
              onPressed: () async {
                final shouldLogout = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Logout"),
                      content: const Text("Are you sure you want to logout?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text("Cancel"),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text("Logout"),
                        ),
                      ],
                    );
                  },
                );

                if (shouldLogout != true) return;

                if (Get.isRegistered<ContactController>()) {
                  final controller = Get.find<ContactController>();

                  controller.contacts.clear();
                  controller.favouriteContacts.clear();
                }

                await authController.logout();

                Get.offAll(() => const LoginScreen());
              },
              icon: const Icon(Icons.logout_rounded, color: Colors.red),
              label: const Text(
                "Logout",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.bodySmall),

                const SizedBox(height: 4),

                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
