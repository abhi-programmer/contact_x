import 'package:contact_x/features/contacts/data/datasources/expense_local_datasource.dart';
import 'package:contact_x/features/contacts/data/datasources/expense_local_datasource_impl.dart';
import 'package:contact_x/features/contacts/data/repositories/expense_repository_impl.dart';
import 'package:contact_x/features/contacts/domain/repositories/expense_repository.dart';
import 'package:contact_x/features/contacts/domain/usecases/add_expense.dart';
import 'package:contact_x/features/contacts/domain/usecases/delete_expense.dart';
import 'package:contact_x/features/contacts/domain/usecases/get_expense.dart';
import 'package:contact_x/features/contacts/domain/usecases/get_expense_by_contact.dart';
import 'package:contact_x/features/contacts/domain/usecases/update_expense.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';



Future<void> initDependencies() async {
  await Hive.initFlutter();

 
  // OPEN BOXES
 
  if (!Hive.isBoxOpen('expenses_box')) {
    await Hive.openBox<Map>('expenses_box');
  }

  
  // EXPENSE DATASOURCE

  if (!Get.isRegistered<ExpenseLocalDataSource>()) {
    Get.lazyPut<ExpenseLocalDataSource>(
      () => ExpenseLocalDataSourceImpl(
        expenseBox: Hive.box<Map>('expenses_box'),
      ),
      fenix: true,
    );
  }

 
  // EXPENSE REPOSITORY

  if (!Get.isRegistered<ExpenseRepository>()) {
    Get.lazyPut<ExpenseRepository>(
      () => ExpenseRepositoryImpl(
        localDataSource: Get.find<ExpenseLocalDataSource>(),
      ),
      fenix: true,
    );
  }

 
  // EXPENSE USECASES
 
  if (!Get.isRegistered<AddExpense>()) {
    Get.lazyPut<AddExpense>(
      () => AddExpense(Get.find<ExpenseRepository>()),
      fenix: true,
    );
  }

  if (!Get.isRegistered<UpdateExpense>()) {
    Get.lazyPut<UpdateExpense>(
      () => UpdateExpense(Get.find<ExpenseRepository>()),
      fenix: true,
    );
  }

  if (!Get.isRegistered<DeleteExpense>()) {
    Get.lazyPut<DeleteExpense>(
      () => DeleteExpense(Get.find<ExpenseRepository>()),
      fenix: true,
    );
  }

  if (!Get.isRegistered<GetExpenses>()) {
    Get.lazyPut<GetExpenses>(
      () => GetExpenses(Get.find<ExpenseRepository>()),
      fenix: true,
    );
  }

  if (!Get.isRegistered<GetExpensesByContact>()) {
    Get.lazyPut<GetExpensesByContact>(
      () => GetExpensesByContact(Get.find<ExpenseRepository>()),
      fenix: true,
    );
  }
}