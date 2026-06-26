import 'package:contact_x/features/contacts/domain/entities/contact.dart';

abstract class ContactRepository {
  Future<bool> checkContactPermission();
  Future<bool> requestContactPermission();
  Future<List<Contact>> getDeviceContacts();
}