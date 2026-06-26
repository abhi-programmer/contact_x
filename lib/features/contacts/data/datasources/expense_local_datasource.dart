import '../models/expense_model.dart';

abstract class ExpenseLocalDataSource {
  Future<void> addExpense(ExpenseModel expense);

  Future<void> updateExpense(ExpenseModel expense);

  Future<void> deleteExpense(String expenseId);

  Stream<List<ExpenseModel>> getExpenses();

  Future<List<ExpenseModel>> getExpensesByContact(String contactId);
}