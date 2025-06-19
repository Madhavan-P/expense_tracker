import 'package:expense_tracker/model/expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExpenseProvider extends ChangeNotifier {
  final List<Expense> _list = [
    Expense(
      type: TrackerType.expense,
      title: 'Flutter Course',
      amount: 99.99,
      date: DateTime.now(),
      description: 'Flutter Course description',
      category: Category.bills,
    ),
    Expense(
      type: TrackerType.income,
      title: 'salary',
      amount: 119.89,
      date: DateTime.now(),
      description: 'salary description',
      category: Category.shopping,
    ),
  ];

  List<Expense> get expenses => _list;

  void addExpenses(Expense expense) {
    print(expense);
    _list.add(expense);
    notifyListeners();
  }

  void remove(Expense expense) {
    _list.remove(expense);
    notifyListeners();
  }

  void undoRemove(Expense expense, int index) {
    _list.insert(index, expense);
    notifyListeners();
  }

  double get totalBalance {
    double total = 0.0;
    for (final exp in _list) {
      if (exp.type == TrackerType.income) {
        total += exp.amount;
      } else {
        total -= exp.amount;
      }
    }
    return total;
  }
}
