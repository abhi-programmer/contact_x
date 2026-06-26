class Contact {
  final String id;
  final String firstName;
  final String lastName;
  final String company;
  final String jobTitle;
  final String email;
  final String phone;
  final String notes;
  final bool isFavourite;

  const Contact({
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

  String get fullName => '$firstName $lastName'.trim();

  Contact copyWith({
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
    return Contact(
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