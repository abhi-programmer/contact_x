import 'package:contact_x/features/contacts/domain/entities/contact.dart';

class ContactModel extends Contact {
  const ContactModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.company,
    required super.jobTitle,
    required super.email,
    required super.phone,
    required super.notes,
    required super.isFavourite,
  });

  factory ContactModel.fromMap(Map<String, dynamic> map) {
    final displayName = (map['displayName'] ?? '') as String;
    final nameParts = displayName.trim().split(' ');

    final firstName = nameParts.isNotEmpty ? nameParts.first : '';
    final lastName = nameParts.length > 1
        ? nameParts.sublist(1).join(' ')
        : '';

    return ContactModel(
      id: (map['id'] ?? '').toString(),
      firstName: firstName,
      lastName: lastName,
      company: '',
      jobTitle: '',
      email: (map['email'] ?? '') as String,
      phone: (map['phone'] ?? '') as String,
      notes: '',
      isFavourite: false,
    );
  }

  Contact toEntity() {
    return Contact(
      id: id,
      firstName: firstName,
      lastName: lastName,
      company: company,
      jobTitle: jobTitle,
      email: email,
      phone: phone,
      notes: notes,
      isFavourite: isFavourite,
    );
  }
}