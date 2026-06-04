import 'package:contact_x/controllers/contact_controller.dart';
import 'package:contact_x/models/contact_model.dart';
import 'package:contact_x/widgets/app_button.dart';
import 'package:contact_x/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class AddEditContactScreen extends StatefulWidget {
  final bool isEdit;
  final String? contactId;
  final bool? isFavourite;
  final String? firstName;
  final String? lastName;
  final String? company;
  final String? jobTitle;
  final String? email;
  final String? phone;
  final String? notes;

  const AddEditContactScreen({
    super.key,
    this.isEdit = false,
    this.contactId,
    this.isFavourite = false,
    this.firstName,
    this.lastName,
    this.company,
    this.jobTitle,
    this.email,
    this.phone,
    this.notes,
  });

  @override
  State<AddEditContactScreen> createState() => _AddEditContactScreenState();
}

class _AddEditContactScreenState extends State<AddEditContactScreen> {
  final ContactController contactController = Get.find<ContactController>();
  final _formKey = GlobalKey<FormState>();

  final Uuid uuid = const Uuid();

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

    firstNameController = TextEditingController(text: widget.firstName ?? '');

    lastNameController = TextEditingController(text: widget.lastName ?? '');

    companyController = TextEditingController(text: widget.company ?? '');

    jobTitleController = TextEditingController(text: widget.jobTitle ?? '');

    emailController = TextEditingController(text: widget.email ?? '');

    phoneController = TextEditingController(text: widget.phone ?? '');

    notesController = TextEditingController(text: widget.notes ?? '');
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
    final title = widget.isEdit ? 'Edit Contact' : 'Add Contact';

    final buttonText = widget.isEdit ? 'Update Contact' : 'Save Contact';

    final buttonIcon = widget.isEdit
        ? Icons.edit_outlined
        : Icons.save_outlined;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
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
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'First name is required';
                            }

                            return null;
                          },
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
                    child: Icon(Icons.phone_outlined),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppTextField(
                      controller: phoneController,
                      hintText: "Phone",
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Phone number is required';
                        }

                        val = val.trim();

                        if (!RegExp(r'^[0-9]+$').hasMatch(val)) {
                          return 'Only digits are allowed';
                        }

                        if (!RegExp(r'^[6-9]').hasMatch(val)) {
                          return 'Mobile number must start with 6, 7, 8 or 9';
                        }

                        if (val.length != 10) {
                          return 'Mobile number must be 10 digits';
                        }

                        return null;
                      },
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
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return null;
                        }

                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(val.trim())) {
                          return 'Enter valid email address';
                        }

                        return null;
                      },
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

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: AppButton(
            text: buttonText,
            icon: buttonIcon,
            onPressed: () async {
              if (!_formKey.currentState!.validate()) {
                return;
              }

              final contact = ContactModel(
                id: widget.isEdit ? widget.contactId! : uuid.v4(),
                firstName: firstNameController.text.trim(),
                lastName: lastNameController.text.trim(),
                company: companyController.text.trim(),
                jobTitle: jobTitleController.text.trim(),
                email: emailController.text.trim(),
                phone: phoneController.text.trim(),
                notes: notesController.text.trim(),
                isFavourite: widget.isFavourite ?? false,
              );

              if (widget.isEdit) {
                await contactController.updateContact(contact);
              } else {
                await contactController.addContact(contact);
              }

              if (!mounted) return;

              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }
}
