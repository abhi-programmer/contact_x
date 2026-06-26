import '../entities/expense.dart';

abstract class ExpenseRepository {
  Future<void> addExpense(Expense expense);

  Future<void> updateExpense(Expense expense);

  Future<void> deleteExpense(String expenseId);

  Stream<List<Expense>> getExpenses();

  Future<List<Expense>> getExpensesByContact(String contactId);
}