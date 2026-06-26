import 'package:contact_x/features/contacts/domain/entities/expense.dart';
import 'package:contact_x/features/contacts/presentation/controllers/expense_controller.dart';
import 'package:contact_x/features/contacts/presentation/pages/add_expense/add_expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';

import 'package:contact_x/features/contacts/domain/entities/contact.dart';
import 'package:contact_x/features/contacts/presentation/controllers/contact_controller.dart';
import 'package:contact_x/features/contacts/presentation/widgets/profile_tile.dart';


class ContactDetailPage extends StatelessWidget {
  final Contact contact;

  const ContactDetailPage({
    super.key,
    required this.contact,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final contactController = Get.find<ContactController>();
    final expenseController = Get.find<ExpenseController>();

    return Obx(() {
      final latestContact =
          contactController.contacts.firstWhereOrNull(
                (e) => e.id == contact.id,
              ) ??
              contact;

      final List<Expense> contactExpenses =
          expenseController.getExpensesByContact(latestContact.id);

      final double totalSpent =
          expenseController.getTotalExpenseByContact(latestContact.id);

      final double foodTotal = expenseController.getCategoryTotal(
        latestContact.id,
        ExpenseCategory.food,
      );

      final double travelTotal = expenseController.getCategoryTotal(
        latestContact.id,
        ExpenseCategory.travel,
      );

      final double personalTotal = expenseController.getCategoryTotal(
        latestContact.id,
        ExpenseCategory.personal,
      );

      return Scaffold(
        appBar: AppBar(
          title: const Text("Contact Details"),
        ),

        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Get.to(
              () => AddExpensePage(
                contact: latestContact,
              ),
            );
          },
          icon: const Icon(Icons.add),
          label: const Text("Add Expense"),
        ),

        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
           
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withOpacity(0.5),
                  ),
                  
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 42,
                      backgroundColor: colorScheme.primary.withOpacity(0.12),
                      child: Text(
                        latestContact.fullName.isNotEmpty
                            ? latestContact.fullName[0].toUpperCase()
                            : "?",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    Text(
                      latestContact.fullName.isNotEmpty
                          ? latestContact.fullName
                          : "Unnamed Contact",
                      textAlign: TextAlign.center,
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    if (latestContact.jobTitle.isNotEmpty ||
                        latestContact.company.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        [
                          latestContact.jobTitle,
                          latestContact.company,
                        ].where((e) => e.isNotEmpty).join(" • "),
                        textAlign: TextAlign.center,
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.65),
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Get.to(
                                () => AddExpensePage(
                                  contact: latestContact,
                                ),
                              );
                            },
                            icon: const Icon(Icons.add),
                            label: const Text("Add Expense"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              //Expense Summary Card
            
              _SectionTitle(
                title: "Expense Summary",
                icon: Icons.account_balance_wallet_outlined,
              ),

              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary.withOpacity(0.95),
                      colorScheme.primary.withOpacity(0.75),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withOpacity(0.18),
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Spent",
                      style: textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "₹${totalSpent.toStringAsFixed(2)}",
                      style: textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: _ExpenseStatCard(
                            title: "Food",
                            amount: foodTotal,
                            icon: Icons.restaurant_outlined,
                            backgroundColor: Colors.white.withOpacity(0.12),
                            textColor: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _ExpenseStatCard(
                            title: "Travel",
                            amount: travelTotal,
                            icon: Icons.directions_car_outlined,
                            backgroundColor: Colors.white.withOpacity(0.12),
                            textColor: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _ExpenseStatCard(
                            title: "Personal",
                            amount: personalTotal,
                            icon: Icons.person_outline,
                            backgroundColor: Colors.white.withOpacity(0.12),
                            textColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// =========================
              /// Contact Info
              /// =========================
              _SectionTitle(
                title: "Contact Information",
                icon: Icons.badge_outlined,
              ),

              const SizedBox(height: 12),

              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: colorScheme.outlineVariant.withOpacity(0.5),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      if (latestContact.firstName.isNotEmpty) ...[
                        ProfileTile(
                          icon: Icons.person_outline,
                          title: "First Name",
                          value: latestContact.firstName,
                        ),
                        const Divider(),
                      ],

                      if (latestContact.lastName.isNotEmpty) ...[
                        ProfileTile(
                          icon: Icons.person_outline,
                          title: "Last Name",
                          value: latestContact.lastName,
                        ),
                        const Divider(),
                      ],

                      if (latestContact.company.isNotEmpty) ...[
                        ProfileTile(
                          icon: Icons.business_outlined,
                          title: "Company",
                          value: latestContact.company,
                        ),
                        const Divider(),
                      ],

                      if (latestContact.jobTitle.isNotEmpty) ...[
                        ProfileTile(
                          icon: Icons.work_outline,
                          title: "Job Title",
                          value: latestContact.jobTitle,
                        ),
                        const Divider(),
                      ],

                      if (latestContact.email.isNotEmpty) ...[
                        ProfileTile(
                          icon: Icons.email_outlined,
                          title: "Email",
                          value: latestContact.email,
                        ),
                        const Divider(),
                      ],

                      if (latestContact.phone.isNotEmpty) ...[
                        ProfileTile(
                          icon: Icons.phone_outlined,
                          title: "Phone",
                          value: latestContact.phone,
                        ),
                      ],

                      if (latestContact.notes.isNotEmpty) ...[
                        if (latestContact.phone.isNotEmpty)
                          const Divider(),
                        ProfileTile(
                          icon: Icons.description_outlined,
                          title: "Notes",
                          value: latestContact.notes,
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// =========================
              /// Recent Expenses Header
              /// =========================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _SectionTitle(
                    title: "Recent Expenses",
                    icon: Icons.receipt_long_outlined,
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Get.to(
                        () => AddExpensePage(
                          contact: latestContact,
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Add"),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              if (contactExpenses.isEmpty)
                _EmptyExpenseState(
                  onAddExpense: () {
                    Get.to(
                      () => AddExpensePage(
                        contact: latestContact,
                      ),
                    );
                  },
                )
              else
                Column(
                  children: contactExpenses
                      .take(10)
                      .map(
                        (expense) => Padding(
                          padding:  EdgeInsets.only(bottom: 12),
                          child: _ExpenseListTile(
                            expense: expense,
                            contact: latestContact,
                          ),
                        ),
                      )
                      .toList(),
                ),
            ],
          ),
        ),
      );
    });
  }
}


// Section Title

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionTitle({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.10),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            size: 20,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}


// Expense summary small card

class _ExpenseStatCard extends StatelessWidget {
  final String title;
  final double amount;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;

  const _ExpenseStatCard({
    required this.title,
    required this.amount,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(icon, color: textColor, size: 20),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: textColor.withOpacity(0.95),
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "₹${amount.toStringAsFixed(0)}",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}


// Empty expense state

class _EmptyExpenseState extends StatelessWidget {
  final VoidCallback onAddExpense;

  const _EmptyExpenseState({
    required this.onAddExpense,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.add,
            size: 52,
            color: colorScheme.primary.withOpacity(0.8),
          ),
          const SizedBox(height: 14),
          Text(
            "No expenses added yet",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onAddExpense,
            icon: const Icon(Icons.add),
            label: const Text("Add Expense"),
          ),
        ],
      ),
    );
  }
}


class _ExpenseListTile extends StatelessWidget {
  final Expense expense;
  final Contact contact;

  const _ExpenseListTile({
    required this.expense,
    required this.contact,
  });

  Color _categoryColor(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.food:
        return Colors.orange;
      case ExpenseCategory.travel:
        return Colors.blue;
      case ExpenseCategory.personal:
        return Colors.purple;
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

  String _categoryLabel(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.food:
        return "Food";
      case ExpenseCategory.travel:
        return "Travel";
      case ExpenseCategory.personal:
        return "Personal";
    }
  }

  Future<void> _showDeleteDialog(
    BuildContext context,
    ExpenseController expenseController,
  ) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text("Delete Expense"),
        content: const Text(
          "Are you sure you want to delete this expense?",
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text("Cancel"),
          ),
          FilledButton(
            onPressed: () => Get.back(result: true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await expenseController.deleteExpense(expense.id);

      Get.snackbar(
        "Deleted",
        "Expense deleted successfully",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _categoryColor(expense.category);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final expenseController = Get.find<ExpenseController>();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colorScheme.outlineVariant.withOpacity(0.45),
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  _categoryIcon(expense.category),
                  color: color,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      expense.note.trim().isEmpty
                          ? _categoryLabel(expense.category)
                          : expense.note,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _ChipLabel(
                          icon: _categoryIcon(expense.category),
                          label: _categoryLabel(expense.category),
                          color: color,
                        ),
                        _ChipLabel(
                          icon: Icons.calendar_today_outlined,
                          label: expense.date.toLocal().toString(),
                          color: colorScheme.primary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              Text(
                "₹${expense.amount.toStringAsFixed(2)}",
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Get.to(
                      () => AddExpensePage(
                        contact: contact,
                        isEdit: true,
                        expense: expense,
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text("Edit"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    _showDeleteDialog(context, expenseController);
                  },
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: const Text("Delete"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChipLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _ChipLabel({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}