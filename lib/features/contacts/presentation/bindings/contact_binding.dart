import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_x/features/contacts/data/datasources/contact_remote_datasource.dart';
import 'package:contact_x/features/contacts/data/datasources/contact_remote_datasource_impl.dart';
import 'package:contact_x/features/contacts/data/repositories/contact_repository_impl.dart';
import 'package:contact_x/features/contacts/domain/repositories/contact_repository.dart';
import 'package:contact_x/features/contacts/domain/usecases/add_contact.dart';
import 'package:contact_x/features/contacts/domain/usecases/delete_contact.dart';
import 'package:contact_x/features/contacts/domain/usecases/get_contacts.dart';
import 'package:contact_x/features/contacts/domain/usecases/get_favourite_contacts.dart';
import 'package:contact_x/features/contacts/domain/usecases/toggle_favourite.dart';
import 'package:contact_x/features/contacts/domain/usecases/update_contact.dart';
import 'package:contact_x/features/contacts/presentation/controllers/contact_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ContactBinding extends Bindings {
  @override
  void dependencies() {
    /// Firebase

    Get.lazyPut<FirebaseFirestore>(
      () => FirebaseFirestore.instance,
      fenix: true,
    );

    Get.lazyPut<FirebaseAuth>(() => FirebaseAuth.instance, fenix: true);

    /// Datasource

    Get.lazyPut<ContactRemoteDataSource>(
      () => ContactRemoteDataSourceImpl(
        firestore: Get.find<FirebaseFirestore>(),
        auth: Get.find<FirebaseAuth>(),
      ),
      fenix: true,
    );

    /// Repository

    Get.lazyPut<ContactRepository>(
      () => ContactRepositoryImpl(remoteDataSource: Get.find()),
      fenix: true,
    );

    /// UseCases

    Get.lazyPut(() => AddContact(Get.find<ContactRepository>()), fenix: true);

    Get.lazyPut(
      () => UpdateContact(Get.find<ContactRepository>()),
      fenix: true,
    );

    Get.lazyPut(
      () => DeleteContact(Get.find<ContactRepository>()),
      fenix: true,
    );

    Get.lazyPut(() => GetContacts(Get.find<ContactRepository>()), fenix: true);

    Get.lazyPut(
      () => GetFavouriteContacts(Get.find<ContactRepository>()),
      fenix: true,
    );

    Get.lazyPut(
      () => ToggleFavourite(Get.find<ContactRepository>()),
      fenix: true,
    );

    /// Controller

    Get.lazyPut<ContactController>(
      () => ContactController(
        addContactUseCase: Get.find(),
        updateContactUseCase: Get.find(),
        deleteContactUseCase: Get.find(),
        getContactsUseCase: Get.find(),
        getFavouriteContactsUseCase: Get.find(),
        toggleFavouriteUseCase: Get.find(),
      ),
      fenix: true,
    );
  }
}
