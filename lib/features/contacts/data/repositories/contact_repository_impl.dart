import 'package:contact_x/features/contacts/data/datasources/contact_remote_datasource.dart';
import 'package:contact_x/features/contacts/data/models/contact_model.dart';
import 'package:contact_x/features/contacts/domain/entities/contact.dart';
import 'package:contact_x/features/contacts/domain/repositories/contact_repository.dart';

class ContactRepositoryImpl implements ContactRepository {
  final ContactRemoteDataSource remoteDataSource;

  ContactRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> addContact(Contact contact) async {
    await remoteDataSource.addContact(ContactModel.fromEntity(contact));
  }

  @override
  Future<void> updateContact(Contact contact) async {
    await remoteDataSource.updateContact(ContactModel.fromEntity(contact));
  }

  @override
  Future<void> deleteContact(String contactId) async {
    await remoteDataSource.deleteContact(contactId);
  }

  @override
  Stream<List<Contact>> getContacts() {
    return remoteDataSource.getContacts();
  }

  @override
  Stream<List<Contact>> getFavouriteContacts() {
    return remoteDataSource.getFavouriteContacts();
  }
}
