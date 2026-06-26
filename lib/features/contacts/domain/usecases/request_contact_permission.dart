import '../repositories/contact_repository.dart';

class RequestContactPermission {
  final ContactRepository repository;

  RequestContactPermission(this.repository);

  Future<bool> call() {
    return repository.requestContactPermission();
  }
}