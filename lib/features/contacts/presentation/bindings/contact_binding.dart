import 'package:contact_x/core/constants/contacts_platform_service.dart';
import 'package:contact_x/features/contacts/data/datasources/contact_local_datasource.dart';
import 'package:contact_x/features/contacts/data/datasources/contact_local_datasource_impl.dart';
import 'package:get/get.dart';


import '../../data/repositories/contact_repository_impl.dart';
import '../../domain/repositories/contact_repository.dart';
import '../../domain/usecases/check_contact_permission.dart';
import '../../domain/usecases/request_contact_permission.dart';
import '../../domain/usecases/get_device_contacts.dart';
import '../controllers/contact_controller.dart';

class ContactBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContactPlatformService>(
      () => ContactPlatformService(),
      fenix: true,
    );

    Get.lazyPut<ContactLocalDataSource>(
      () => ContactLocalDataSourceImpl(
        platformService: Get.find<ContactPlatformService>(),
      ),
      fenix: true,
    );

    Get.lazyPut<ContactRepository>(
      () => ContactRepositoryImpl(
        localDataSource: Get.find<ContactLocalDataSource>(),
      ),
      fenix: true,
    );

    Get.lazyPut(
      () => CheckContactPermission(Get.find<ContactRepository>()),
      fenix: true,
    );

    Get.lazyPut(
      () => RequestContactPermission(Get.find<ContactRepository>()),
      fenix: true,
    );

    Get.lazyPut(
      () => GetDeviceContacts(Get.find<ContactRepository>()),
      fenix: true,
    );

    Get.lazyPut<ContactController>(
      () => ContactController(
        checkContactPermissionUseCase: Get.find(),
        requestContactPermissionUseCase: Get.find(),
        getDeviceContactsUseCase: Get.find(),
      ),
      fenix: true,
    );

    
  }
}