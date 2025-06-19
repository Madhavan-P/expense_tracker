import 'package:expense_tracker/widgets/expense_list/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/model/expense.dart';
import 'package:intl/intl.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList({
    super.key,
    required this.expenseList,
    required this.onRemoveExpenses,
  });

  final void Function(Expense expense) onRemoveExpenses;
  final List<Expense> expenseList;

  // Group expenses by date
  Map<String, List<Expense>> _groupExpensesByDate() {
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));

    final Map<String, List<Expense>> groupedExpenses = {};

    for (final expense in expenseList) {
      final expenseDate = expense.date;
      String dateLabel;

      if (expenseDate.year == today.year &&
          expenseDate.month == today.month &&
          expenseDate.day == today.day) {
        dateLabel = 'Today';
      } else if (expenseDate.year == yesterday.year &&
          expenseDate.month == yesterday.month &&
          expenseDate.day == yesterday.day) {
        dateLabel = 'Yesterday';
      } else {
        dateLabel = DateFormat('MMMM d, y').format(expenseDate);
      }

      if (!groupedExpenses.containsKey(dateLabel)) {
        groupedExpenses[dateLabel] = [];
      }
      groupedExpenses[dateLabel]!.add(expense);
    }

    return groupedExpenses;
  }

  @override
  Widget build(BuildContext context) {
    final groupedExpenses = _groupExpensesByDate();
    final sortedDates =
        groupedExpenses.keys.toList()..sort((a, b) {
          if (a == 'Today') return -1;
          if (b == 'Today') return 1;
          if (a == 'Yesterday') return -1;
          if (b == 'Yesterday') return 1;
          return b.compareTo(a);
        });

    return ListView.builder(
      itemCount: sortedDates.length,
      itemBuilder: (ctx, index) {
        final date = sortedDates[index];
        final expenses = groupedExpenses[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                date,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            ...expenses.map(
              (expense) => Dismissible(
                background: Container(
                  color: Theme.of(context).colorScheme.error,
                  margin: EdgeInsets.symmetric(
                    horizontal: Theme.of(context).cardTheme.margin!.horizontal,
                  ),
                ),
                onDismissed: (direction) => onRemoveExpenses(expense),
                key: ValueKey(expense),
                child: ExpenseItem(expense),
              ),
            ),
          ],
        );
      },
    );
  }
}
