import 'package:expense_tracker/model/expense.dart';
import 'package:flutter/material.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem(this.expenses, {super.key});

  final Expense expenses;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: (Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  expenses.title.toUpperCase(),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Spacer(),
                Text(
                  expenses.type.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Text(
                  expenses.type == TrackerType.income
                      ? '+ ₹${expenses.amount.toStringAsFixed(2)}'
                      : '- ₹${expenses.amount.toStringAsFixed(2)}',
                  style: TextStyle(color: textColor),
                ),
                Spacer(),
                Row(
                  children: [
                    Icon(categoryIcons[expenses.category]),
                    SizedBox(width: 4),
                    Text(
                      expenses.formattedDate,
                      style: TextStyle(color: textColor),
                    ),
                  ],
                ),
              ],
            ),
          ],
        )),
      ),
    );
  }
}
