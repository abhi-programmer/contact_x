import 'package:contact_x/features/contacts/domain/entities/contact.dart';
import 'package:contact_x/features/contacts/presentation/controllers/contact_controller.dart';
import 'package:contact_x/features/contacts/presentation/pages/add_edit_contact/add_edit_contact_page.dart';
import 'package:contact_x/features/contacts/presentation/widgets/profile_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactDetailPage extends StatefulWidget {
  final Contact contact;

  const ContactDetailPage({super.key, required this.contact});

  @override
  State<ContactDetailPage> createState() => _ContactDetailPageState();
}

class _ContactDetailPageState extends State<ContactDetailPage> {
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
                await Get.to(
                  () => AddEditContactPage(isEdit: true, contact: contact),
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
                      ProfileTile(
                        icon: Icons.person_outline,
                        title: "First Name",
                        value: contact.firstName,
                      ),
                      const Divider(),
                    ],

                    if (contact.lastName.isNotEmpty) ...[
                      ProfileTile(
                        icon: Icons.person_outline,
                        title: "Last Name",
                        value: contact.lastName,
                      ),
                      const Divider(),
                    ],

                    if (contact.company.isNotEmpty) ...[
                      ProfileTile(
                        icon: Icons.business_outlined,
                        title: "Company",
                        value: contact.company,
                      ),
                      const Divider(),
                    ],

                    if (contact.jobTitle.isNotEmpty) ...[
                      ProfileTile(
                        icon: Icons.work_outline,
                        title: "Job Title",
                        value: contact.jobTitle,
                      ),
                      const Divider(),
                    ],

                    if (contact.email.isNotEmpty) ...[
                      ProfileTile(
                        icon: Icons.email_outlined,
                        title: "Email",
                        value: contact.email,
                      ),
                      const Divider(),
                    ],

                    ProfileTile(
                      icon: Icons.phone_outlined,
                      title: "Phone",
                      value: contact.phone,
                    ),

                    if (contact.notes.isNotEmpty) ...[
                      const Divider(),

                      ProfileTile(
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
