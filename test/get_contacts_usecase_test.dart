// import 'package:contact_x/features/contacts/domain/entities/contact.dart';
// import 'package:contact_x/features/contacts/domain/repositories/contact_repository.dart';
// import 'package:contact_x/features/contacts/domain/usecases/get_contacts.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';

// class MockContactRepository extends Mock implements ContactRepository {}

// void main() {
//   late GetContacts useCase;
//   late MockContactRepository repository;

//   setUp(() {
//     repository = MockContactRepository();
//     useCase = GetContacts(repository);
//   });

//   final contacts = [
//     const Contact(
//       id: '1',
//       firstName: 'Abhay',
//       lastName: 'Sananse',
//       company: 'Houzeo',
//       jobTitle: 'Flutter Developer',
//       email: 'abhay@test.com',
//       phone: '9999999999',
//       notes: 'Test Contact',
//       isFavourite: true,
//     ),
//   ];

//   test('should return contacts stream from repository', () async {
//     // Arrange
//     when(
//       () => repository.getContacts(),
//     ).thenAnswer((_) => Stream.value(contacts));

//     // Act & Assert
//     expect(useCase(), emits(contacts));

//     verify(() => repository.getContacts()).called(1);
//   });
// }
