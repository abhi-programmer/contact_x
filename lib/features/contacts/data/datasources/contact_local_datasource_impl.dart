import 'package:contact_x/core/constants/contacts_platform_service.dart';
import 'package:contact_x/features/contacts/data/models/contact_model.dart';

import 'contact_local_datasource.dart';

class ContactLocalDataSourceImpl
    implements ContactLocalDataSource {
  final ContactPlatformService platformService;

  ContactLocalDataSourceImpl({
    required this.platformService,
  });

  @override
  Future<bool> checkContactPermission() {
    return platformService.checkPermission();
  }

  @override
  Future<bool> requestContactPermission() {
    return platformService.requestPermission();
  }

  @override
  Future<List<ContactModel>> getDeviceContacts() async {
    final rawContacts = await platformService.fetchContacts();

    return rawContacts
        .map(ContactModel.fromMap)
        .toList();
  }
}