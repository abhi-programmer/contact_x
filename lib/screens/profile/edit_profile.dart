import 'package:contact_x/widgets/app_button.dart';
import 'package:contact_x/widgets/app_text_field.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;
  late final TextEditingController companyController;
  late final TextEditingController jobTitleController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  late final TextEditingController notesController;

  @override
  void initState() {
    super.initState();

    firstNameController = TextEditingController(text: "Hemang");

    lastNameController = TextEditingController(text: "Goswami");

    companyController = TextEditingController(text: "OpenAI");

    jobTitleController = TextEditingController(text: "Flutter Developer");

    emailController = TextEditingController(text: "hemang@example.com");

    phoneController = TextEditingController(text: "+91 98765 43210");

    notesController = TextEditingController(
      text: "Building beautiful Flutter applications.",
    );
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    companyController.dispose();
    jobTitleController.dispose();
    emailController.dispose();
    phoneController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 14),
                  child: Icon(Icons.person_outline),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: [
                      AppTextField(
                        controller: firstNameController,
                        hintText: "First name",
                      ),
                      const SizedBox(height: 12),
                      AppTextField(
                        controller: lastNameController,
                        hintText: "Last name",
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 14),
                  child: Icon(Icons.business_outlined),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: [
                      AppTextField(
                        controller: companyController,
                        hintText: "Company",
                      ),
                      const SizedBox(height: 12),
                      AppTextField(
                        controller: jobTitleController,
                        hintText: "Job title",
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 14),
                  child: Icon(Icons.email_outlined),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppTextField(
                    controller: emailController,
                    hintText: "Email",
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 14),
                  child: Icon(Icons.phone_outlined),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppTextField(
                    controller: phoneController,
                    hintText: "Phone",
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 14),
                  child: Icon(Icons.description_outlined),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppTextField(
                    controller: notesController,
                    hintText: "Notes",
                    maxLines: 5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: AppButton(
            text: "Update Profile",
            icon: Icons.save_outlined,
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
