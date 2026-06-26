import 'package:contact_x/features/contacts/domain/entities/expense.dart';
import 'package:contact_x/features/contacts/presentation/controllers/expense_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:contact_x/features/contacts/domain/entities/contact.dart';


class AddExpensePage extends StatefulWidget {
  final Contact contact;
  final bool isEdit;
  final Expense? expense;

  const AddExpensePage({
    super.key,
    required this.contact,
    this.isEdit = false,
    this.expense,
  });

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final ExpenseController expenseController = Get.find<ExpenseController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Uuid _uuid = const Uuid();

  late final TextEditingController amountController;
  late final TextEditingController noteController;

  late ExpenseCategory selectedCategory;
  late DateTime selectedDate;

  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    amountController = TextEditingController(
      text: widget.expense != null
          ? _formatInitialAmount(widget.expense!.amount)
          : '',
    );

    noteController = TextEditingController(
      text: widget.expense?.note ?? '',
    );

    selectedCategory =
        widget.expense?.category ?? ExpenseCategory.food;

    selectedDate = widget.expense?.date ?? DateTime.now();
  }

  String _formatInitialAmount(double amount) {
    if (amount == amount.toInt()) {
      return amount.toInt().toString();
    }
    return amount.toString();
  }

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(now.year - 10),
      lastDate: DateTime(now.year + 10),
    );

    if (picked != null) {
      setState(() {
        selectedDate = DateTime(
          picked.year,
          picked.month,
          picked.day,
        );
      });
    }
  }

  Future<void> _saveExpense() async {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.tryParse(amountController.text.trim()) ?? 0;

    final expense = Expense(
      id: widget.isEdit
          ? widget.expense!.id
          : _uuid.v4(),
      contactId: widget.contact.id,
      amount: amount,
      note: noteController.text.trim(),
      category: selectedCategory,
      date: selectedDate,
    );

    try {
      setState(() {
        isSaving = true;
      });

      if (widget.isEdit) {
        await expenseController.updateExpense(expense);
      } else {
        await expenseController.addExpense(expense);
      }

      if (!mounted) return;

      Get.back();

      Get.snackbar(
        "Success",
        widget.isEdit
            ? "Expense updated successfully"
            : "Expense added successfully",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        widget.isEdit
            ? "Failed to update expense"
            : "Failed to add expense",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  String _categoryLabel(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.food:
        return 'FOOD';
      case ExpenseCategory.travel:
        return 'TRAVEL';
      case ExpenseCategory.personal:
        return 'PERSONAL';
    }
  }

  IconData _categoryIcon(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.food:
        return Icons.restaurant_outlined;
      case ExpenseCategory.travel:
        return Icons.directions_car_outlined;
      case ExpenseCategory.personal:
        return Icons.person_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.isEdit ? 'Edit Expense' : 'Add Expense';
    final buttonText = widget.isEdit ? 'Update Expense' : 'Save Expense';
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              /// =========================
              /// Selected Contact Card
              /// =========================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withOpacity(0.5),
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor:
                          colorScheme.primary.withOpacity(0.12),
                      child: Text(
                        widget.contact.fullName.isNotEmpty
                            ? widget.contact.fullName[0].toUpperCase()
                            : "?",
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Selected Contact",
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.65),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.contact.fullName.isNotEmpty
                                ? widget.contact.fullName
                                : "Unnamed Contact",
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (widget.contact.phone.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              widget.contact.phone,
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface.withOpacity(0.70),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// =========================
              /// Amount
              /// =========================
              _SectionCard(
                title: "Expense Amount",
                icon: Icons.currency_rupee,
                child: TextFormField(
                  controller: amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    hintText: "Enter amount",
                    prefixIcon: Icon(Icons.currency_rupee),
                  ),
                  validator: (value) {
                    final raw = value?.trim() ?? '';

                    if (raw.isEmpty) {
                      return 'Expense amount is required';
                    }

                    final amount = double.tryParse(raw);

                    if (amount == null) {
                      return 'Enter a valid amount';
                    }

                    if (amount <= 0) {
                      return 'Amount must be greater than 0';
                    }

                    return null;
                  },
                ),
              ),

              const SizedBox(height: 16),

              /// =========================
              /// Note
              /// =========================
              _SectionCard(
                title: "Expense Note",
                icon: Icons.description_outlined,
                child: TextFormField(
                  controller: noteController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: "Add note (optional)",
                    alignLabelWithHint: true,
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(bottom: 70),
                      child: Icon(Icons.notes_outlined),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// =========================
              /// Category
              /// =========================
              _SectionCard(
                title: "Expense Category",
                icon: Icons.category_outlined,
                child: DropdownButtonFormField<ExpenseCategory>(
                  value: selectedCategory,
                  decoration: const InputDecoration(
                    hintText: "Select category",
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                  items: ExpenseCategory.values.map((category) {
                    return DropdownMenuItem<ExpenseCategory>(
                      value: category,
                      child: Row(
                        children: [
                          Icon(_categoryIcon(category), size: 20),
                          const SizedBox(width: 10),
                          Text(_categoryLabel(category)),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                ),
              ),

              const SizedBox(height: 16),

              /// =========================
              /// Date
              /// =========================
              _SectionCard(
                title: "Expense Date",
                icon: Icons.calendar_today_outlined,
                child: InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(16),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.calendar_today_outlined),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedDate.toString(),
                          style: textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_down_rounded),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        child: SizedBox(
          height: 56,
          child: FilledButton.icon(
            onPressed: isSaving ? null : _saveExpense,
            icon: isSaving
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Icon(
                    widget.isEdit
                        ? Icons.edit_outlined
                        : Icons.save_outlined,
                  ),
            label: Text(buttonText),
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}