import '../entities/expense.dart';
import '../repositories/expense_repository.dart';

class GetExpensesByContact {
  final ExpenseRepository repository;

  GetExpensesByContact(this.repository);

  Future<List<Expense>> call(String contactId) async {
    return await repository.getExpensesByContact(contactId);
  }
}