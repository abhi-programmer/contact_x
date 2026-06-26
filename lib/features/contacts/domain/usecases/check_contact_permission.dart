import 'package:contact_x/features/contacts/domain/repositories/contact_repository.dart';

class CheckContactPermission {
  final ContactRepository repository;

  CheckContactPermission(this.repository);

  Future<bool> call() {
    return repository.checkContactPermission();
  }
}