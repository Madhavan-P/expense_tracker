import 'dart:convert';
import 'package:expense_tracker/model/expenseProvider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:expense_tracker/model/expense.dart';
import 'package:provider/provider.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({
    super.key,
    required this.totalBalance,
    required this.token,
    required this.id,
  });

  final String token;
  final String id;
  final double totalBalance;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime? selectedDate;
  Category selectedCategory = Category.food;
  TrackerType selectedType = TrackerType.expense;

  final formatter = DateFormat.yMd();
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    void selectDatePicker() async {
      final now = DateTime.now();
      final _firstDate = DateTime(now.year - 1, now.month, now.day);
      final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: _firstDate,
        lastDate: now,
      );
      setState(() {
        selectedDate = pickedDate;
      });
    }

    void addDataBackend() async {
      final newExpense = Expense(
        title: titleController.text,
        amount: double.tryParse(amountController.text) ?? 0.0,
        date: selectedDate!,
        description: descriptionController.text,
        category: selectedCategory,
        type: selectedType,
      );

      final reqBody = jsonEncode(newExpense.toJson(widget.id));

      var response = await http.post(
        Uri.parse("http://10.0.2.2:3000/api/expenses/"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${widget.token}",
        },

        body: reqBody,
      );
      print(response.statusCode);

      if (response.statusCode == 201) {
        return;
      } else {
        print("Failed: ${response.body}");
      }
    }

    void submittedExpenses() async {
      final enteredAmount = double.tryParse(amountController.text);

      final validAmount = enteredAmount == null || enteredAmount <= 0;

      if (titleController.text.trim().isEmpty ||
          validAmount ||
          descriptionController.text.trim().isEmpty ||
          selectedDate == null) {
        showDialog(
          context: context,
          builder:
              (ctx) => AlertDialog(
                title: Text(
                  "Invalid Input",
                  style: TextStyle(color: textColor),
                ),
                content: Text(
                  "Please make sure the all the fields have valid inputs",
                  style: TextStyle(color: textColor),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    child: Text("okay"),
                  ),
                ],
              ),
        );
        return;
      }
      if (selectedType == TrackerType.expense &&
          enteredAmount! > widget.totalBalance) {
        showDialog(
          context: context,
          builder:
              (ctx) => AlertDialog(
                title: Text(
                  "Insufficient Balance",
                  style: TextStyle(color: textColor),
                ),
                content: Text(
                  "You don't have enough balance to add this expense.",
                  style: TextStyle(color: textColor),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text("OK"),
                  ),
                ],
              ),
        );
        return;
      }
      addDataBackend();
      final data = Expense(
        type: selectedType,
        title: titleController.text,
        amount: enteredAmount,
        date: selectedDate!,
        description: descriptionController.text,
        category: selectedCategory,
      );
      Provider.of<ExpenseProvider>(context, listen: false).addExpenses(data);
      Navigator.pop(context);
    }

    @override
    void dispose() {
      titleController.dispose();
      amountController.dispose();
      descriptionController.dispose();
      super.dispose();
    }

    return Consumer<ExpenseProvider>(
      builder:
          (context, ExpenseProvider, child) => Padding(
            padding: EdgeInsets.fromLTRB(16, 60, 16, 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropdownButton(
                      style: TextStyle(color: textColor),
                      value: selectedType,
                      items:
                          TrackerType.values
                              .map(
                                (type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(type.name.toUpperCase()),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setState(() {
                          selectedType = value!;
                        });
                      },
                    ),
                    Text(
                      'Total Balance: ₹${widget.totalBalance.toStringAsFixed(2)}',
                      style: TextStyle(color: textColor),
                    ),
                  ],
                ),
                TextField(
                  style: TextStyle(color: textColor),
                  controller: titleController,
                  maxLength: 50,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(label: Text("title")),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: TextStyle(color: textColor),
                        controller: amountController,
                        maxLength: 50,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          prefixText: "₹ ",
                          label: Text("amount"),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            style: TextStyle(color: textColor),
                            selectedDate == null
                                ? 'No Select Date'
                                : formatter.format(selectedDate!),
                          ),
                          IconButton(
                            onPressed: selectDatePicker,
                            icon: Icon(Icons.calendar_month),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                TextField(
                  style: TextStyle(color: textColor),
                  controller: descriptionController,
                  maxLength: 50,
                  maxLines: 3,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(label: Text("description")),
                ),
                Row(
                  children: [
                    DropdownButton(
                      style: TextStyle(color: textColor),
                      value: selectedCategory,
                      items:
                          Category.values
                              .map(
                                (category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(category.name.toUpperCase()),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setState(() {
                          selectedCategory = value!;
                        });
                      },
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: submittedExpenses,
                      child: Text("Save Expenses"),
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }
}
