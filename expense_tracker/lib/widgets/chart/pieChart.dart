import 'package:expense_tracker/model/expense.dart';
import 'package:expense_tracker/model/expenseProvider.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpensePieChart extends StatelessWidget {
  final List<Expense> expenses;

  const ExpensePieChart({super.key, required this.expenses});

  Map<Category, double> get _categoryTotals {
    final Map<Category, double> data = {};
    for (final expense in expenses) {
      if (expense.type == TrackerType.expense) {
        data.update(
          expense.category,
          (value) => value + expense.amount,
          ifAbsent: () => expense.amount,
        );
      }
    }
    return data;
  }

  List<PieChartSectionData> get _sections {
    final total = _categoryTotals.values.fold(
      0.0,
      (sum, amount) => sum + amount,
    );
    return _categoryTotals.entries.map((entry) {
      final percentage = (entry.value / total) * 100;
      return PieChartSectionData(
        value: entry.value,
        title: "${entry.key.name}\n${percentage.toStringAsFixed(1)}%",
        color: _getCategoryColor(entry.key),
        radius: 80,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(blurRadius: 2, color: Colors.black54, offset: Offset(1, 1)),
          ],
        ),
        titlePositionPercentageOffset: 0.65,
      );
    }).toList();
  }

  Color _getCategoryColor(Category category) {
    switch (category) {
      case Category.food:
        return Colors.deepOrange;
      case Category.travel:
        return Colors.indigo;
      case Category.shopping:
        return Colors.pinkAccent;
      case Category.bills:
        return Colors.deepPurple;
      case Category.others:
      default:
        return Colors.teal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExpenseProvider>(context);
    if (_categoryTotals.isEmpty) {
      return const Center(child: Text("No expense data available"));
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Chart(expenses: provider.expenses),
            const SizedBox(height: 24),
            SizedBox(
              height: 380,
              child: PieChart(
                PieChartData(
                  sections: _sections,
                  centerSpaceRadius: 50,
                  sectionsSpace: 6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
