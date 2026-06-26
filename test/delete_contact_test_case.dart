// import 'package:contact_x/features/contacts/domain/repositories/contact_repository.dart';
// import 'package:contact_x/features/contacts/domain/usecases/delete_contact.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';

// class MockContactRepository extends Mock implements ContactRepository {}

// void main() {
//   late DeleteContact useCase;
//   late MockContactRepository repository;

//   setUp(() {
//     repository = MockContactRepository();
//     useCase = DeleteContact(repository);
//   });

//   const contactId = '1';

//   test('should call repository.deleteContact once', () async {
//     // Arrange
//     when(() => repository.deleteContact(contactId)).thenAnswer((_) async {});

//     // Act
//     await useCase(contactId);

//     // Assert
//     verify(() => repository.deleteContact(contactId)).called(1);

//     verifyNoMoreInteractions(repository);
//   });
// }
