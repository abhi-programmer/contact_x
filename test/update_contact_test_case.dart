// import 'package:contact_x/features/contacts/domain/entities/contact.dart';
// import 'package:contact_x/features/contacts/domain/repositories/contact_repository.dart';
// import 'package:contact_x/features/contacts/domain/usecases/update_contact.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';

// class MockContactRepository extends Mock implements ContactRepository {}

// void main() {
//   late UpdateContact useCase;
//   late MockContactRepository repository;

//   setUp(() {
//     repository = MockContactRepository();
//     useCase = UpdateContact(repository);
//   });

//   final contact = Contact(
//     id: '1',
//     firstName: 'Abhay',
//     lastName: 'Sananse',
//     company: 'Houzeo',
//     jobTitle: 'Flutter Developer',
//     email: 'abhay@test.com',
//     phone: '9999999999',
//     notes: 'Updated Contact',
//     isFavourite: true,
//   );

//   test('should call repository.updateContact once', () async {
//     // Arrange
//     when(() => repository.updateContact(contact)).thenAnswer((_) async {});

//     // Act
//     await useCase(contact);

//     // Assert
//     verify(() => repository.updateContact(contact)).called(1);

//     verifyNoMoreInteractions(repository);
//   });
// }
