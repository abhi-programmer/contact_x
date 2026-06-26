import '../../domain/entities/expense.dart';

class ExpenseModel extends Expense {
  const ExpenseModel({
    required super.id,
    required super.contactId,
    required super.amount,
    required super.note,
    required super.category,
    required super.date,
  });

  factory ExpenseModel.fromEntity(Expense expense) {
    return ExpenseModel(
      id: expense.id,
      contactId: expense.contactId,
      amount: expense.amount,
      note: expense.note,
      category: expense.category,
      date: expense.date,
    );
  }

  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
      id: map['id'] as String? ?? '',
      contactId: map['contactId'] as String? ?? '',
      amount: _parseAmount(map['amount']),
      note: map['note'] as String? ?? '',
      category: _parseCategory(map['category']),
      date: _parseDate(map['date']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'contactId': contactId,
      'amount': amount,
      'note': note,
      'category': category.name,
      'date': date.toIso8601String(),
    };
  }

  Expense toEntity() {
    return Expense(
      id: id,
      contactId: contactId,
      amount: amount,
      note: note,
      category: category,
      date: date,
    );
  }

  static double _parseAmount(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }

  static ExpenseCategory _parseCategory(dynamic value) {
    final raw = (value?.toString() ?? '').toLowerCase();

    switch (raw) {
      case 'food':
        return ExpenseCategory.food;
      case 'travel':
        return ExpenseCategory.travel;
      case 'personal':
        return ExpenseCategory.personal;
      default:
        return ExpenseCategory.personal;
    }
  }

  static DateTime _parseDate(dynamic value) {
    if (value is DateTime) return value;

    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }

    return DateTime.now();
  }
}