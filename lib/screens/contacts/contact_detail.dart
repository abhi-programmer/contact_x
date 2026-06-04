import 'package:contact_x/controllers/contact_controller.dart';
import 'package:flutter/material.dart';

import 'package:contact_x/models/contact_model.dart';
import 'package:contact_x/screens/contacts/add_edit_contacts.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactDetailsScreen extends StatefulWidget {
  final ContactModel contact;

  const ContactDetailsScreen({super.key, required this.contact});

  @override
  State<ContactDetailsScreen> createState() => _ContactDetailsScreenState();
}

class _ContactDetailsScreenState extends State<ContactDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final contactController = Get.find<ContactController>();

    final contact = contactController.contacts.firstWhere(
      (e) => e.id == widget.contact.id,
      orElse: () => widget.contact,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Details"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilledButton.icon(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddEditContactScreen(
                      isEdit: true,
                      contactId: contact.id,
                      firstName: contact.firstName,
                      lastName: contact.lastName,
                      company: contact.company,
                      jobTitle: contact.jobTitle,
                      email: contact.email,
                      phone: contact.phone,
                      notes: contact.notes,
                      isFavourite: contact.isFavourite,
                    ),
                  ),
                );

                if (mounted) {
                  setState(() {});
                }
              },
              icon: const Icon(Icons.edit_outlined),
              label: const Text("Edit"),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 55,
              backgroundColor: colorScheme.surfaceContainerHighest,
              child: Text(
                contact.fullName.isNotEmpty
                    ? contact.fullName[0].toUpperCase()
                    : "?",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 16),

            Text(
              contact.fullName,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),

            if (contact.jobTitle.isNotEmpty || contact.company.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                [
                  contact.jobTitle,
                  contact.company,
                ].where((e) => e.isNotEmpty).join(" • "),
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
              ),
            ],

            const SizedBox(height: 20),

            FilledButton.icon(
              onPressed: () async {
                final status = await Permission.phone.request();

                if (!status.isGranted) {
                  return;
                }

                await FlutterPhoneDirectCaller.callNumber(contact.phone);
              },
              icon: const Icon(Icons.call),
              label: const Text("Call Contact"),
            ),

            const SizedBox(height: 28),

            Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    if (contact.firstName.isNotEmpty) ...[
                      _ProfileTile(
                        icon: Icons.person_outline,
                        title: "First Name",
                        value: contact.firstName,
                      ),
                      const Divider(),
                    ],

                    if (contact.lastName.isNotEmpty) ...[
                      _ProfileTile(
                        icon: Icons.person_outline,
                        title: "Last Name",
                        value: contact.lastName,
                      ),
                      const Divider(),
                    ],

                    if (contact.company.isNotEmpty) ...[
                      _ProfileTile(
                        icon: Icons.business_outlined,
                        title: "Company",
                        value: contact.company,
                      ),
                      const Divider(),
                    ],

                    if (contact.jobTitle.isNotEmpty) ...[
                      _ProfileTile(
                        icon: Icons.work_outline,
                        title: "Job Title",
                        value: contact.jobTitle,
                      ),
                      const Divider(),
                    ],

                    if (contact.email.isNotEmpty) ...[
                      _ProfileTile(
                        icon: Icons.email_outlined,
                        title: "Email",
                        value: contact.email,
                      ),
                      const Divider(),
                    ],

                    _ProfileTile(
                      icon: Icons.phone_outlined,
                      title: "Phone",
                      value: contact.phone,
                    ),

                    if (contact.notes.isNotEmpty) ...[
                      const Divider(),
                      _ProfileTile(
                        icon: Icons.description_outlined,
                        title: "Notes",
                        value: contact.notes,
                      ),
                    ],
                  ],
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
