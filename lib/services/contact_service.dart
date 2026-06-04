import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_x/models/contact_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ContactService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _contactsCollection {
    final uid = _auth.currentUser?.uid;

    if (uid == null) {
      return _firestore
          .collection("users")
          .doc("_dummy_")
          .collection("contacts");
    }

    return _firestore.collection("users").doc(uid).collection("contacts");
  }

  Future<void> addContact(ContactModel contact) async {
    await _contactsCollection.doc(contact.id).set(contact.toJson());
  }

  Future<void> updateContact(ContactModel contact) async {
    await _contactsCollection.doc(contact.id).update(contact.toJson());
  }

  Future<void> deleteContact(String contactId) async {
    await _contactsCollection.doc(contactId).delete();
  }

  Stream<List<ContactModel>> getContacts() {
    return _contactsCollection
        .orderBy("firstName")
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ContactModel.fromJson(doc.data()))
              .toList(),
        );
  }

  Stream<List<ContactModel>> getFavouriteContacts() {
    return _contactsCollection
        .where("isFavourite", isEqualTo: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ContactModel.fromJson(doc.data()))
              .toList(),
        );
  }
}
