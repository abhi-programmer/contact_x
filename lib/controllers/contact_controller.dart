import 'dart:async';

import 'package:contact_x/models/contact_model.dart';
import 'package:contact_x/services/contact_service.dart';
import 'package:get/get.dart';

class ContactController extends GetxController {
  final ContactService _contactService = ContactService();

  final RxBool isLoading = false.obs;

  final RxString searchQuery = ''.obs;

  final RxList<ContactModel> contacts = <ContactModel>[].obs;

  final RxList<ContactModel> favouriteContacts = <ContactModel>[].obs;

  StreamSubscription? _contactsSubscription;
  StreamSubscription? _favouriteSubscription;

  @override
  void onInit() {
    super.onInit();

    _listenContacts();
    _listenFavouriteContacts();
  }

  void _listenContacts() {
    _contactsSubscription = _contactService.getContacts().listen((data) {
      contacts.assignAll(data);
    });
  }

  void _listenFavouriteContacts() {
    _favouriteSubscription = _contactService.getFavouriteContacts().listen((
      data,
    ) {
      favouriteContacts.assignAll(data);
    });
  }

  Future<void> addContact(ContactModel contact) async {
    await _contactService.addContact(contact);
  }

  Future<void> updateContact(ContactModel contact) async {
    await _contactService.updateContact(contact);
  }

  Future<void> deleteContact(String contactId) async {
    await _contactService.deleteContact(contactId);
  }

  Future<void> reloadContacts() async {
    await _contactsSubscription?.cancel();
    await _favouriteSubscription?.cancel();

    contacts.clear();
    favouriteContacts.clear();

    _listenContacts();
    _listenFavouriteContacts();
  }

  @override
  void onClose() {
    _contactsSubscription?.cancel();
    _favouriteSubscription?.cancel();
    super.onClose();
  }

  Future<void> toggleFavourite(ContactModel contact) async {
    await _contactService.updateContact(
      contact.copyWith(isFavourite: !contact.isFavourite),
    );
  }
}
