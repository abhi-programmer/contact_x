

import 'package:contact_x/features/contacts/domain/entities/expense.dart';
import 'package:contact_x/features/contacts/domain/repositories/expense_repository.dart';

class AddExpense {
  final ExpenseRepository repository;

  AddExpense(this.repository);

  Future<void> call(Expense expense) async {
    await repository.addExpense(expense);
  }
}