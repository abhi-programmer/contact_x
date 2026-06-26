import 'package:get/get.dart';

import '../../domain/entities/contact.dart';
import '../../domain/usecases/check_contact_permission.dart';
import '../../domain/usecases/request_contact_permission.dart';
import '../../domain/usecases/get_device_contacts.dart';

class ContactController extends GetxController {
  final CheckContactPermission checkContactPermissionUseCase;
  final RequestContactPermission requestContactPermissionUseCase;
  final GetDeviceContacts getDeviceContactsUseCase;

  ContactController({
    required this.checkContactPermissionUseCase,
    required this.requestContactPermissionUseCase,
    required this.getDeviceContactsUseCase,
  });

  final RxBool isLoading = false.obs;
  final RxBool hasPermission = false.obs;
  final RxString permissionMessage = ''.obs;

  final RxList<Contact> contacts = <Contact>[].obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    initializeContacts();
  }

  // Future<void> initializeContacts() async {
  //   isLoading.value = true;

  //   try {
  //     final granted = await checkContactPermissionUseCase();

  //     if (granted) {
  //       hasPermission.value = true;
  //       permissionMessage.value = '';
  //       await loadContacts();
  //     } else {
  //       final requested = await requestContactPermissionUseCase();

  //       if (requested) {
  //         hasPermission.value = true;
  //         permissionMessage.value = '';
  //         await loadContacts();
  //       } else {
  //         hasPermission.value = false;
  //         permissionMessage.value =
  //             'Contact permission denied. Please allow access to continue.';
  //       }
  //     }
  //   } catch (e) {
  //     hasPermission.value = false;
  //     permissionMessage.value =
  //         'Something went wrong while accessing contacts.';
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
  Future<void> initializeContacts() async {
  isLoading.value = true;

  try {
    final granted = await checkContactPermissionUseCase();

    if (granted) {
      hasPermission.value = true;
      permissionMessage.value = '';
      await loadContacts();
    } else {
      hasPermission.value = false;
      permissionMessage.value =
          'Contact permission denied. Please allow access to continue.';
    }
  } catch (e) {
    hasPermission.value = false;
    permissionMessage.value =
        'Something went wrong while accessing contacts.';
  } finally {
    isLoading.value = false;
  }
}

  // Future<void> retryPermission() async {
  //   isLoading.value = true;

  //   try {
  //     final granted = await requestContactPermissionUseCase();

  //     if (granted) {
  //       hasPermission.value = true;
  //       permissionMessage.value = '';
  //       await loadContacts();
  //     } else {
  //       hasPermission.value = false;
  //       permissionMessage.value =
  //           'Contact permission denied. Please allow access to continue.';
  //     }
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
  Future<void> retryPermission() async {
  isLoading.value = true;

  try {
    final granted = await requestContactPermissionUseCase();

    if (granted) {
      hasPermission.value = true;
      permissionMessage.value = '';
      await loadContacts();
    } else {
      hasPermission.value = false;
      permissionMessage.value =
          'Contact permission denied. Please allow access to continue.';
    }
  } catch (e) {
    hasPermission.value = false;
    permissionMessage.value =
        'Unable to request contacts permission.';
  } finally {
    isLoading.value = false;
  }
}

  List<Contact> get filteredContacts {
  final query = searchQuery.value.trim().toLowerCase();

  if (query.isEmpty) {
    final sorted = [...contacts];
    sorted.sort(
      (a, b) => a.fullName.toLowerCase().compareTo(
            b.fullName.toLowerCase(),
          ),
    );
    return sorted;
  }

  final filtered = contacts.where((contact) {
    return contact.fullName.toLowerCase().contains(query) ||
        contact.phone.toLowerCase().contains(query) ||
        contact.email.toLowerCase().contains(query) ||
        contact.company.toLowerCase().contains(query) ||
        contact.jobTitle.toLowerCase().contains(query);
  }).toList();

  filtered.sort(
    (a, b) => a.fullName.toLowerCase().compareTo(
          b.fullName.toLowerCase(),
        ),
  );

  return filtered;
}

  Future<void> loadContacts() async {
    final result = await getDeviceContactsUseCase();
    contacts.assignAll(result);
  }
}