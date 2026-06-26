// import 'package:contact_x/features/contacts/domain/entities/contact.dart';
// import 'package:contact_x/features/contacts/presentation/controllers/contact_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:uuid/uuid.dart';

// class AddEditContactPage extends StatefulWidget {
//   final bool isEdit;
//   final Contact? contact;

//   const AddEditContactPage({super.key, this.isEdit = false, this.contact});

//   @override
//   State<AddEditContactPage> createState() => _AddEditContactPageState();
// }

// class _AddEditContactPageState extends State<AddEditContactPage> {
//   final ContactController contactController = Get.find<ContactController>();

//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   final Uuid uuid = const Uuid();

//   late final TextEditingController firstNameController;

//   late final TextEditingController lastNameController;

//   late final TextEditingController companyController;

//   late final TextEditingController jobTitleController;

//   late final TextEditingController emailController;

//   late final TextEditingController phoneController;

//   late final TextEditingController notesController;

//   @override
//   void initState() {
//     super.initState();

//     firstNameController = TextEditingController(
//       text: widget.contact?.firstName ?? '',
//     );

//     lastNameController = TextEditingController(
//       text: widget.contact?.lastName ?? '',
//     );

//     companyController = TextEditingController(
//       text: widget.contact?.company ?? '',
//     );

//     jobTitleController = TextEditingController(
//       text: widget.contact?.jobTitle ?? '',
//     );

//     emailController = TextEditingController(text: widget.contact?.email ?? '');

//     phoneController = TextEditingController(text: widget.contact?.phone ?? '');

//     notesController = TextEditingController(text: widget.contact?.notes ?? '');
//   }

//   @override
//   void dispose() {
//     firstNameController.dispose();
//     lastNameController.dispose();
//     companyController.dispose();
//     jobTitleController.dispose();
//     emailController.dispose();
//     phoneController.dispose();
//     notesController.dispose();
//     super.dispose();
//   }

//   Future<void> saveContact() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }

//     final contact = Contact(
//       id: widget.isEdit ? widget.contact!.id : uuid.v4(),

//       firstName: firstNameController.text.trim(),

//       lastName: lastNameController.text.trim(),

//       company: companyController.text.trim(),

//       jobTitle: jobTitleController.text.trim(),

//       email: emailController.text.trim(),

//       phone: phoneController.text.trim(),

//       notes: notesController.text.trim(),

//       isFavourite: widget.contact?.isFavourite ?? false,
//     );

//     if (widget.isEdit) {
//       await contactController.updateContact(contact);
//     } else {
//       await contactController.addContact(contact);
//     }

//     if (!mounted) return;

//     Navigator.pop(context);
//     // Get.back();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final title = widget.isEdit ? "Edit Contact" : "Add Contact";

//     final buttonText = widget.isEdit ? "Update Contact" : "Save Contact";

//     final buttonIcon = widget.isEdit
//         ? Icons.edit_outlined
//         : Icons.save_outlined;

//     return Scaffold(
//       appBar: AppBar(title: Text(title)),

//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),

//         child: Form(
//           key: _formKey,

//           child: Column(
//             children: [
//               TextFormField(
//                 controller: firstNameController,

//                 decoration: const InputDecoration(
//                   labelText: "First Name",
//                   border: OutlineInputBorder(),
//                 ),

//                 validator: (value) {
//                   if (value == null || value.trim().isEmpty) {
//                     return "First name is required";
//                   }

//                   return null;
//                 },
//               ),

//               const SizedBox(height: 16),

//               TextFormField(
//                 controller: lastNameController,

//                 decoration: const InputDecoration(
//                   labelText: "Last Name",
//                   border: OutlineInputBorder(),
//                 ),
//               ),

//               const SizedBox(height: 16),

//               TextFormField(
//                 controller: phoneController,
//                 autovalidateMode: AutovalidateMode.onUserInteraction,
//                 keyboardType: TextInputType.phone,
//                 inputFormatters: [
//                   LengthLimitingTextInputFormatter(10),

//                   FilteringTextInputFormatter.digitsOnly,
//                 ],
//                 decoration: const InputDecoration(
//                   labelText: "Phone",
//                   border: OutlineInputBorder(),
//                 ),

//                 validator: (value) {
//                   if (value == null || value.trim().isEmpty) {
//                     return "Phone number is required";
//                   }
//                   value = value.trim();
//                   if(!RegExp(r'^[0-9]+$').hasMatch(value)) {
//                     return "Phone number must contain only digits";
//                   }
//                   if(!RegExp(r'^[6-9]').hasMatch(value)) {
//                     return "Phone must start with 6, 7, 8 or 9";
//                   }
//                   if(value.length != 10) {
//                     return "Phone number must be exactly 10 digits";
//                   }

//                   return null;
//                 },
//               ),

//               const SizedBox(height: 16),

//               TextFormField(
//                 controller: companyController,

//                 decoration: const InputDecoration(
//                   labelText: "Company",
//                   border: OutlineInputBorder(),
//                 ),
//               ),

//               const SizedBox(height: 16),

//               TextFormField(
//                 controller: jobTitleController,

//                 decoration: const InputDecoration(
//                   labelText: "Job Title",
//                   border: OutlineInputBorder(),
//                 ),
//               ),

//               const SizedBox(height: 16),

//               TextFormField(
//                 controller: emailController,

//                 keyboardType: TextInputType.emailAddress,

//                 decoration: const InputDecoration(
//                   labelText: "Email",
//                   border: OutlineInputBorder(),
//                 ),

//                 validator: (value) {
//                   if (value == null || value.trim().isEmpty) {
//                     return null;
//                   }

//                   final emailRegex = RegExp(
//                     r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$',
//                   );

//                   if (!emailRegex.hasMatch(value.trim())) {
//                     return "Enter valid email";
//                   }

//                   return null;
//                 },
//               ),

//               const SizedBox(height: 16),

//               TextFormField(
//                 controller: notesController,

//                 maxLines: 5,

//                 decoration: const InputDecoration(
//                   labelText: "Notes",
//                   border: OutlineInputBorder(),
//                 ),
//               ),

//               const SizedBox(height: 40),

//               SizedBox(
//                 width: double.infinity,

//                 height: 55,

//                 child: ElevatedButton.icon(
//                   onPressed: saveContact,

//                   icon: Icon(buttonIcon),

//                   label: Text(buttonText),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
