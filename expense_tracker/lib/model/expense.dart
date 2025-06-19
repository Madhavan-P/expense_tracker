import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

const uuid = Uuid();

enum Category { food, travel, shopping, bills, others }

enum TrackerType { income, expense }

final formatter = DateFormat.yMd();

const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight_takeoff,
  Category.shopping: Icons.shopping_cart,
  Category.bills: Icons.receipt_long,
  Category.others: Icons.category,
};

class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.description,
    required this.type,
  }) : id = uuid.v4();

  final String id;
  final TrackerType type;
  final String title;
  final double amount;
  final DateTime date;
  final String description;
  final Category category;

  String get formattedDate {
    return formatter.format(date);
  }

  Map<String, dynamic> toJson(String userId) {
    return {
      "user_id": userId,
      "title": title,
      "amount": amount,
      "date": date.toIso8601String(),
      "description": description,
      "category": category.name,
      "type": type.name,
    };
  }
}

class ExpenseBucket {
  const ExpenseBucket({required this.expenses, required this.category});

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
    : expenses =
          allExpenses
              .where(
                (expense) =>
                    expense.category == category &&
                    expense.type == TrackerType.expense,
              )
              .toList();

  final Category category;
  final List<Expense> expenses;

  double get totalExpenses {
    double sum = 0;

    for (final expense in expenses) {
      sum += expense.amount;
    }
    return sum;
  }
}
