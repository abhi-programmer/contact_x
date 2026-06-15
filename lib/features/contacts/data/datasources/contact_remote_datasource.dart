import 'package:contact_x/features/contacts/data/models/contact_model.dart';

abstract class ContactRemoteDataSource {
  Future<void> addContact(ContactModel contact);

  Future<void> updateContact(ContactModel contact);

  Future<void> deleteContact(String contactId);

  Stream<List<ContactModel>> getContacts();

  Stream<List<ContactModel>> getFavouriteContacts();
}
