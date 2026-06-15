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

  factory ContactModel.fromEntity(Contact contact) {
    return ContactModel(
      id: contact.id,
      firstName: contact.firstName,
      lastName: contact.lastName,
      company: contact.company,
      jobTitle: contact.jobTitle,
      email: contact.email,
      phone: contact.phone,
      notes: contact.notes,
      isFavourite: contact.isFavourite,
    );
  }

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json["id"] ?? "",
      firstName: json["firstName"] ?? "",
      lastName: json["lastName"] ?? "",
      company: json["company"] ?? "",
      jobTitle: json["jobTitle"] ?? "",
      email: json["email"] ?? "",
      phone: json["phone"] ?? "",
      notes: json["notes"] ?? "",
      isFavourite: json["isFavourite"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstName": firstName,
    "lastName": lastName,
    "company": company,
    "jobTitle": jobTitle,
    "email": email,
    "phone": phone,
    "notes": notes,
    "isFavourite": isFavourite,
  };
}
