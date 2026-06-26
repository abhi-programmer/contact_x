import 'package:contact_x/features/contacts/data/datasources/contact_local_datasource.dart';
import 'package:contact_x/features/contacts/domain/entities/contact.dart';
import 'package:contact_x/features/contacts/domain/repositories/contact_repository.dart';



class ContactRepositoryImpl implements ContactRepository {
  final ContactLocalDataSource localDataSource;

  ContactRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<bool> checkContactPermission() {
    return localDataSource.checkContactPermission();
  }

  @override
  Future<bool> requestContactPermission() {
    return localDataSource.requestContactPermission();
  }

  @override
  Future<List<Contact>> getDeviceContacts() async {
    final models = await localDataSource.getDeviceContacts();
    return models.map((e) => e.toEntity()).toList();
  }
}