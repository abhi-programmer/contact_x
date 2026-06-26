import 'dart:async';

import 'package:contact_x/features/contacts/domain/usecases/get_expense.dart';
import 'package:contact_x/features/contacts/domain/usecases/get_expense_by_contact.dart';
import 'package:get/get.dart';

import '../../domain/entities/expense.dart';
import '../../domain/usecases/add_expense.dart';
import '../../domain/usecases/delete_expense.dart';
import '../../domain/usecases/update_expense.dart';

class ExpenseController extends GetxController {
  final AddExpense addExpenseUseCase;
  final UpdateExpense updateExpenseUseCase;
  final DeleteExpense deleteExpenseUseCase;
  final GetExpenses getExpensesUseCase;
  final GetExpensesByContact getExpensesByContactUseCase;

  ExpenseController({
    required this.addExpenseUseCase,
    required this.updateExpenseUseCase,
    required this.deleteExpenseUseCase,
    required this.getExpensesUseCase,
    required this.getExpensesByContactUseCase,
  });

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final RxList<Expense> expenses = <Expense>[].obs;

  StreamSubscription<List<Expense>>? _expensesSubscription;

  @override
  void onInit() {
    super.onInit();
    _listenExpenses();
  }

  void _listenExpenses() {
    isLoading.value = true;
    errorMessage.value = '';

    _expensesSubscription?.cancel();

    _expensesSubscription = getExpensesUseCase().listen(
      (data) {
        expenses.assignAll(data);
        isLoading.value = false;
      },
      onError: (error) {
        errorMessage.value = error.toString();
        isLoading.value = false;
      },
    );
  }

  Future<void> addExpense(Expense expense) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await addExpenseUseCase(expense);
    } catch (e) {
      errorMessage.value = 'Failed to add expense';
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateExpense(Expense expense) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await updateExpenseUseCase(expense);
    } catch (e) {
      errorMessage.value = 'Failed to update expense';
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteExpense(String expenseId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await deleteExpenseUseCase(expenseId);
    } catch (e) {
      errorMessage.value = 'Failed to delete expense';
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// =========================
  /// Helpers for UI / Contact Detail Page
  /// =========================

  List<Expense> getExpensesByContact(String contactId) {
    final filtered = expenses
        .where((expense) => expense.contactId == contactId)
        .toList();

    filtered.sort((a, b) => b.date.compareTo(a.date));
    return filtered;
  }

  Future<List<Expense>> fetchExpensesByContact(String contactId) async {
    try {
      return await getExpensesByContactUseCase(contactId);
    } catch (_) {
      return [];
    }
  }

  double getTotalExpenseByContact(String contactId) {
    final contactExpenses = getExpensesByContact(contactId);

    return contactExpenses.fold<double>(
      0,
      (sum, expense) => sum + expense.amount,
    );
  }

  double getCategoryTotal(String contactId, ExpenseCategory category) {
    final contactExpenses = getExpensesByContact(contactId);

    return contactExpenses
        .where((expense) => expense.category == category)
        .fold<double>(
          0,
          (sum, expense) => sum + expense.amount,
        );
  }

  List<Expense> getRecentExpensesByContact(
    String contactId, {
    int limit = 10,
  }) {
    final contactExpenses = getExpensesByContact(contactId);

    if (contactExpenses.length <= limit) {
      return contactExpenses;
    }

    return contactExpenses.take(limit).toList();
  }

  Map<ExpenseCategory, double> getCategorySummary(String contactId) {
    return {
      ExpenseCategory.food: getCategoryTotal(
        contactId,
        ExpenseCategory.food,
      ),
      ExpenseCategory.travel: getCategoryTotal(
        contactId,
        ExpenseCategory.travel,
      ),
      ExpenseCategory.personal: getCategoryTotal(
        contactId,
        ExpenseCategory.personal,
      ),
    };
  }

  @override
  void onClose() {
    _expensesSubscription?.cancel();
    super.onClose();
  }
}