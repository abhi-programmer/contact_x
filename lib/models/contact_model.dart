class ContactModel {
  final String id;
  final String firstName;
  final String lastName;
  final String company;
  final String jobTitle;
  final String email;
  final String phone;
  final String notes;
  final bool isFavourite;

  const ContactModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.company,
    required this.jobTitle,
    required this.email,
    required this.phone,
    required this.notes,
    required this.isFavourite,
  });

  String get fullName => "$firstName $lastName".trim();

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

  Map<String, dynamic> toJson() {
    return {
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

  ContactModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? company,
    String? jobTitle,
    String? email,
    String? phone,
    String? notes,
    bool? isFavourite,
  }) {
    return ContactModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      company: company ?? this.company,
      jobTitle: jobTitle ?? this.jobTitle,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      notes: notes ?? this.notes,
      isFavourite: isFavourite ?? this.isFavourite,
    );
  }
}
