import 'package:contact_x/features/contacts/domain/entities/contact.dart';
import 'package:contact_x/features/contacts/domain/repositories/contact_repository.dart';

class ToggleFavourite {
  final ContactRepository repository;

  ToggleFavourite(this.repository);

  Future<void> call(Contact contact) async {
    await repository.updateContact(
      Contact(
        id: contact.id,
        firstName: contact.firstName,
        lastName: contact.lastName,
        company: contact.company,
        jobTitle: contact.jobTitle,
        email: contact.email,
        phone: contact.phone,
        notes: contact.notes,
        isFavourite: !contact.isFavourite,
      ),
    );
  }
}
