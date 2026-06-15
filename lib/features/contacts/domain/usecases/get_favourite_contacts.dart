import 'package:contact_x/features/contacts/domain/entities/contact.dart';
import 'package:contact_x/features/contacts/domain/repositories/contact_repository.dart';

class GetFavouriteContacts {
  final ContactRepository repository;

  GetFavouriteContacts(this.repository);

  Stream<List<Contact>> call() {
    return repository.getFavouriteContacts();
  }
}
