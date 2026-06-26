enum ExpenseCategory {
  food,
  travel,
 personal,
}

class Expense {
  final String id;
  final String contactId;
  final double amount;
  final String note;
  final ExpenseCategory category;
  final DateTime date;

  const Expense({
    required this.id,
    required this.contactId,
    required this.amount,
    required this.note,
    required this.category,
    required this.date,
  });

  Expense copyWith({
    String? id,
    String? contactId,
    double? amount,
    String? note,
    ExpenseCategory? category,
    DateTime? date,
  }) {
    return Expense(
      id: id ?? this.id,
      contactId: contactId ?? this.contactId,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      category: category ?? this.category,
      date: date ?? this.date,
    );
  }
}