import 'dart:async';

import 'package:contact_x/features/contacts/domain/entities/contact.dart';
import 'package:contact_x/features/contacts/domain/usecases/add_contact.dart';
import 'package:contact_x/features/contacts/domain/usecases/delete_contact.dart';
import 'package:contact_x/features/contacts/domain/usecases/get_contacts.dart';
import 'package:contact_x/features/contacts/domain/usecases/get_favourite_contacts.dart';
import 'package:contact_x/features/contacts/domain/usecases/toggle_favourite.dart';
import 'package:contact_x/features/contacts/domain/usecases/update_contact.dart';
import 'package:get/get.dart';

class ContactController extends GetxController {
  final AddContact addContactUseCase;
  final UpdateContact updateContactUseCase;
  final DeleteContact deleteContactUseCase;
  final GetContacts getContactsUseCase;
  final GetFavouriteContacts getFavouriteContactsUseCase;
  final ToggleFavourite toggleFavouriteUseCase;

  ContactController({
    required this.addContactUseCase,
    required this.updateContactUseCase,
    required this.deleteContactUseCase,
    required this.getContactsUseCase,
    required this.getFavouriteContactsUseCase,
    required this.toggleFavouriteUseCase,
  });

  /// Loading

  final RxBool isLoading = false.obs;

  /// Search

  final RxString searchQuery = ''.obs;

  /// Contacts

  final RxList<Contact> contacts = <Contact>[].obs;

  final RxList<Contact> favouriteContacts = <Contact>[].obs;

  StreamSubscription? _contactsSubscription;
  StreamSubscription? _favouriteSubscription;

  @override
  void onInit() {
    super.onInit();

    _listenContacts();
    _listenFavouriteContacts();
  }

  void _listenContacts() {
    _contactsSubscription = getContactsUseCase().listen(
      (data) {
        contacts.assignAll(data);
      },
      onError: (error) {
        Get.snackbar("Error", error.toString());
      },
    );
  }

  void _listenFavouriteContacts() {
    _favouriteSubscription = getFavouriteContactsUseCase().listen(
      (data) {
        favouriteContacts.assignAll(data);
      },
      onError: (error) {
        Get.snackbar("Error", error.toString());
      },
    );
  }

  Future<void> addContact(Contact contact) async {
    try {
      isLoading.value = true;

      await addContactUseCase(contact);

      Get.snackbar("Success", "Contact added successfully");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateContact(Contact contact) async {
    try {
      isLoading.value = true;

      await updateContactUseCase(contact);

      Get.snackbar("Success", "Contact updated successfully");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteContact(String contactId) async {
    try {
      isLoading.value = true;

      await deleteContactUseCase(contactId);

      Get.snackbar("Success", "Contact deleted successfully");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleFavourite(Contact contact) async {
    try {
      await toggleFavouriteUseCase(contact);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> reloadContacts() async {
    await _contactsSubscription?.cancel();

    await _favouriteSubscription?.cancel();

    contacts.clear();

    favouriteContacts.clear();

    _listenContacts();

    _listenFavouriteContacts();
  }

  List<Contact> get filteredContacts {
    final query = searchQuery.value.toLowerCase().trim();

    if (query.isEmpty) {
      return contacts;
    }

    return contacts.where((contact) {
      return contact.fullName.toLowerCase().contains(query) ||
          contact.phone.toLowerCase().contains(query);
    }).toList();
  }

  @override
  void onClose() {
    _contactsSubscription?.cancel();

    _favouriteSubscription?.cancel();

    super.onClose();
  }
}
