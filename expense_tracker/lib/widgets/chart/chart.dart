import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker/widgets/chart/chart_bar.dart';
import 'package:expense_tracker/model/expense.dart';

class Chart extends StatelessWidget {
  const Chart({super.key, required this.expenses});

  final List<Expense> expenses;

  List<Map<String, Object>> get groupedExpenses {
    final now = DateTime.now();

    return List.generate(7, (index) {
      final weekDay = now.subtract(Duration(days: index));
      double totalSum = 0.0;

      for (final exp in expenses) {
        final isSameDay =
            exp.date.day == weekDay.day &&
            exp.date.month == weekDay.month &&
            exp.date.year == weekDay.year;

        // Only count if type is 'expense'
        if (isSameDay && exp.type == TrackerType.expense) {
          totalSum += exp.amount;
        }
      }

      return {'day': DateFormat.E().format(weekDay), 'amount': totalSum};
    }).reversed.toList();
  }

  double get maxSpending {
    return groupedExpenses.fold(0.0, (sum, item) {
      return sum > (item['amount'] as double)
          ? sum
          : (item['amount'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.3),
            Theme.of(context).colorScheme.primary.withOpacity(0.0),
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children:
                  groupedExpenses.map((data) {
                    final amount = data['amount'] as double;
                    final fill = maxSpending == 0 ? 0.0 : amount / maxSpending;

                    return ChartBar(fill: fill);
                  }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children:
                groupedExpenses.map((data) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        data['day'].toString(),
                        style: TextStyle(
                          color:
                              isDarkMode
                                  ? Theme.of(context).colorScheme.secondary
                                  : Theme.of(
                                    context,
                                  ).colorScheme.primary.withOpacity(0.7),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}
