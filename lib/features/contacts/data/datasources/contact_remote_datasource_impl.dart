import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_x/features/contacts/data/models/contact_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'contact_remote_datasource.dart';

class ContactRemoteDataSourceImpl implements ContactRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ContactRemoteDataSourceImpl({required this.firestore, required this.auth});

  CollectionReference<Map<String, dynamic>> get contactsCollection {
    final uid = auth.currentUser?.uid;

    if (uid == null) {
      return firestore
          .collection("users")
          .doc("_dummy_")
          .collection("contacts");
    }

    return firestore.collection("users").doc(uid).collection("contacts");
  }

  @override
  Future<void> addContact(ContactModel contact) async {
    await contactsCollection.doc(contact.id).set(contact.toJson());
  }

  @override
  Future<void> updateContact(ContactModel contact) async {
    await contactsCollection.doc(contact.id).update(contact.toJson());
  }

  @override
  Future<void> deleteContact(String contactId) async {
    await contactsCollection.doc(contactId).delete();
  }

  @override
  Stream<List<ContactModel>> getContacts() {
    return contactsCollection
        .orderBy("firstName")
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ContactModel.fromJson(doc.data()))
              .toList(),
        );
  }

  @override
  Stream<List<ContactModel>> getFavouriteContacts() {
    return contactsCollection
        .where("isFavourite", isEqualTo: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ContactModel.fromJson(doc.data()))
              .toList(),
        );
  }
}
