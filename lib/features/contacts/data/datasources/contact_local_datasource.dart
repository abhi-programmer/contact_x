import 'package:contact_x/features/contacts/data/models/contact_model.dart';

abstract class ContactLocalDataSource {
  Future<bool> checkContactPermission();
  Future<bool> requestContactPermission();
  Future<List<ContactModel>> getDeviceContacts();
}