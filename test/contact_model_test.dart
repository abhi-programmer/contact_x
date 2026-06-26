// import 'package:flutter_test/flutter_test.dart';
// import 'package:contact_x/features/contacts/data/models/contact_model.dart';
// import 'package:contact_x/features/contacts/domain/entities/contact.dart';

// void main() {
//   group('ContactModel', () {
//     final contactModel = ContactModel(
//       id: '1',
//       firstName: 'Abhay',
//       lastName: 'Sananse',
//       company: 'Houzeo',
//       jobTitle: 'Flutter Developer',
//       email: 'abhay@test.com',
//       phone: '9999999999',
//       notes: 'Test Notes',
//       isFavourite: true,
//     );

//     test('should convert to json correctly', () {
//       final json = contactModel.toJson();

//       expect(json['id'], '1');
//       expect(json['firstName'], 'Abhay');
//       expect(json['lastName'], 'Sananse');
//       expect(json['company'], 'Houzeo');
//       expect(json['jobTitle'], 'Flutter Developer');
//       expect(json['email'], 'abhay@test.com');
//       expect(json['phone'], '9999999999');
//       expect(json['notes'], 'Test Notes');
//       expect(json['isFavourite'], true);
//     });

//     test('should create model from json', () {
//       final json = {
//         'id': '1',
//         'firstName': 'Abhay',
//         'lastName': 'Sananse',
//         'company': 'Houzeo',
//         'jobTitle': 'Flutter Developer',
//         'email': 'abhay@test.com',
//         'phone': '9999999999',
//         'notes': 'Test Notes',
//         'isFavourite': true,
//       };

//       final model = ContactModel.fromJson(json);

//       expect(model.id, '1');
//       expect(model.firstName, 'Abhay');
//       expect(model.lastName, 'Sananse');
//       expect(model.company, 'Houzeo');
//       expect(model.jobTitle, 'Flutter Developer');
//       expect(model.email, 'abhay@test.com');
//       expect(model.phone, '9999999999');
//       expect(model.notes, 'Test Notes');
//       expect(model.isFavourite, true);
//     });

//     test('should create model from entity', () {
//       final entity = Contact(
//         id: '1',
//         firstName: 'Abhay',
//         lastName: 'Sananse',
//         company: 'Houzeo',
//         jobTitle: 'Flutter Developer',
//         email: 'abhay@test.com',
//         phone: '9999999999',
//         notes: 'Test Notes',
//         isFavourite: true,
//       );

//       final model = ContactModel.fromEntity(entity);

//       expect(model.id, entity.id);
//       expect(model.firstName, entity.firstName);
//       expect(model.lastName, entity.lastName);
//       expect(model.company, entity.company);
//       expect(model.jobTitle, entity.jobTitle);
//       expect(model.email, entity.email);
//       expect(model.phone, entity.phone);
//       expect(model.notes, entity.notes);
//       expect(model.isFavourite, entity.isFavourite);
//     });
//   });
// }
