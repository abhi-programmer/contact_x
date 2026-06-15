import 'package:contact_x/features/contacts/domain/repositories/contact_repository.dart';

class DeleteContact {
  final ContactRepository repository;

  DeleteContact(this.repository);

  Future<void> call(String contactId) async {
    await repository.deleteContact(contactId);
  }
}
