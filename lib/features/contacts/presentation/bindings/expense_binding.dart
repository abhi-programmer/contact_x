import 'package:contact_x/features/contacts/domain/usecases/add_expense.dart';
import 'package:contact_x/features/contacts/domain/usecases/delete_expense.dart';
import 'package:contact_x/features/contacts/domain/usecases/get_expense.dart';
import 'package:contact_x/features/contacts/domain/usecases/get_expense_by_contact.dart';
import 'package:contact_x/features/contacts/domain/usecases/update_expense.dart';
import 'package:contact_x/features/contacts/presentation/controllers/expense_controller.dart';
import 'package:get/get.dart';

class ExpenseBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ExpenseController>()) {
      Get.lazyPut<ExpenseController>(
        () => ExpenseController(
          addExpenseUseCase: Get.find<AddExpense>(),
          updateExpenseUseCase: Get.find<UpdateExpense>(),
          deleteExpenseUseCase: Get.find<DeleteExpense>(),
          getExpensesUseCase: Get.find<GetExpenses>(),
          getExpensesByContactUseCase: Get.find<GetExpensesByContact>(),
        ),
        fenix: true,
      );
    }
  }
}