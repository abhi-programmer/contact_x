

import 'package:contact_x/features/contacts/domain/entities/contact.dart';
import 'package:contact_x/features/contacts/domain/repositories/contact_repository.dart';

class GetDeviceContacts {
  final ContactRepository repository;

  GetDeviceContacts(this.repository);

  Future<List<Contact>> call() {
    return repository.getDeviceContacts();
  }
}