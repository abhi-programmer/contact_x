import '../../domain/entities/expense.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/expense_local_datasource.dart';
import '../models/expense_model.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseLocalDataSource localDataSource;

  ExpenseRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<void> addExpense(Expense expense) async {
    final expenseModel = ExpenseModel.fromEntity(expense);
    await localDataSource.addExpense(expenseModel);
  }

  @override
  Future<void> updateExpense(Expense expense) async {
    final expenseModel = ExpenseModel.fromEntity(expense);
    await localDataSource.updateExpense(expenseModel);
  }

  @override
  Future<void> deleteExpense(String expenseId) async {
    await localDataSource.deleteExpense(expenseId);
  }

  @override
  Stream<List<Expense>> getExpenses() {
    return localDataSource.getExpenses().map(
      (expenseModels) => expenseModels
          .map((model) => model.toEntity())
          .toList(),
    );
  }

  @override
  Future<List<Expense>> getExpensesByContact(String contactId) async {
    final expenseModels =
        await localDataSource.getExpensesByContact(contactId);

    return expenseModels
        .map((model) => model.toEntity())
        .toList();
  }
}