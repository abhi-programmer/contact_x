import 'package:contact_x/features/contacts/presentation/controllers/contact_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ContactPermissionPage extends StatelessWidget {
  const ContactPermissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ContactController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts Permission'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Obx(
            () => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.contact_page_outlined,
                  size: 72,
                ),
                const SizedBox(height: 16),
                Text(
                  controller.permissionMessage.value.isEmpty
                      ? 'Contacts permission is required.'
                      : controller.permissionMessage.value,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: controller.retryPermission,
                  child: const Text('Retry Permission'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}