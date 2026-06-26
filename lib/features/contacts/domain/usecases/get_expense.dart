import '../entities/expense.dart';
import '../repositories/expense_repository.dart';

class GetExpenses {
  final ExpenseRepository repository;

  GetExpenses(this.repository);

  Stream<List<Expense>> call() {
    return repository.getExpenses();
  }
}