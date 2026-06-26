import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';

import '../models/expense_model.dart';
import 'expense_local_datasource.dart';

class ExpenseLocalDataSourceImpl implements ExpenseLocalDataSource {
  final Box<Map> expenseBox;

  ExpenseLocalDataSourceImpl({
    required this.expenseBox,
  });

  @override
  Future<void> addExpense(ExpenseModel expense) async {
    try {
      await expenseBox.put(
        expense.id,
        expense.toMap(),
      );
    } catch (e) {
      throw Exception('Failed to add expense: $e');
    }
  }

  @override
  Future<void> updateExpense(ExpenseModel expense) async {
    try {
      final exists = expenseBox.containsKey(expense.id);

      if (!exists) {
        throw Exception('Expense not found for update.');
      }

      await expenseBox.put(
        expense.id,
        expense.toMap(),
      );
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Failed to update expense: $e');
    }
  }

  @override
  Future<void> deleteExpense(String expenseId) async {
    try {
      await expenseBox.delete(expenseId);
    } catch (e) {
      throw Exception('Failed to delete expense: $e');
    }
  }

  @override
  Stream<List<ExpenseModel>> getExpenses() async* {
    yield _getAllExpensesSorted();

    yield* expenseBox.watch().map((_) {
      return _getAllExpensesSorted();
    });
  }

  @override
  Future<List<ExpenseModel>> getExpensesByContact(String contactId) async {
    try {
      final allExpenses = expenseBox.values
          .map(
            (map) => ExpenseModel.fromMap(
              Map<String, dynamic>.from(map),
            ),
          )
          .where((expense) => expense.contactId == contactId)
          .toList();

      allExpenses.sort(
        (a, b) => b.date.compareTo(a.date),
      );

      return allExpenses;
    } catch (e) {
      throw Exception('Failed to fetch expenses by contact: $e');
    }
  }

  List<ExpenseModel> _getAllExpensesSorted() {
    final expenses = expenseBox.values
        .map(
          (map) => ExpenseModel.fromMap(
            Map<String, dynamic>.from(map),
          ),
        )
        .toList();

    expenses.sort(
      (a, b) => b.date.compareTo(a.date),
    );

    return expenses;
  }
}