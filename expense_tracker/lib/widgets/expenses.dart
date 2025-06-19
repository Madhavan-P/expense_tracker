import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:expense_tracker/widgets/authentiation/login.dart';
import 'package:expense_tracker/widgets/chart/pieChart.dart';
import 'package:expense_tracker/widgets/profile.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:expense_tracker/model/expenseProvider.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/model/expense.dart';
import 'package:expense_tracker/widgets/expense_list/Expense_List.dart';
import 'package:provider/provider.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Expenses extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final String? token;

  const Expenses({required this.token, super.key, required this.onToggleTheme});
  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  String? id;
  String? email;
  String? username;
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    if (widget.token != null && widget.token!.isNotEmpty) {
      try {
        final Map<String, dynamic> myDecodedToken = JwtDecoder.decode(
          widget.token!,
        );
        print(myDecodedToken);
        final user = myDecodedToken['user'];
        if (user != null) {
          id = user['user_id'] ?? 'unknown';
          email = user['email'] ?? 'Unknown';
          username = user['username'] ?? 'Unknown';
        }
      } catch (e) {
        print("Invalid token format: $e");
      }
    } else {
      print("Token is null or empty");
    }
  }

  Future<void> downloadExpensesAsCSV(List<Expense> expenses) async {
    try {
      List<List<dynamic>> rows = [
        ["ID", "Title", "Amount", "Date", "Description", "Category", "Type"],
      ];

      for (var exp in expenses) {
        rows.add([
          exp.id,
          exp.title,
          exp.amount,
          exp.date.toIso8601String(),
          exp.description,
          exp.category.name,
          exp.type.name,
        ]);
      }

      String csvData = const ListToCsvConverter().convert(rows);

      final directory = await getDownloadsDirectory();
      if (directory == null) {
        print("❌ Could not access Downloads directory");
        return;
      }

      final file = File(
        "${directory.path}/expenses_${DateTime.now().millisecondsSinceEpoch}.csv",
      );
      await file.writeAsString(csvData);

      print("✅ CSV saved to: ${file.path}");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Expenses saved to Downloads"),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print("❌ Failed to save CSV: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to save CSV: $e"),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void showAddingForm() {
    final list = Provider.of<ExpenseProvider>(context, listen: false);
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder:
          (ctx) => NewExpense(
            totalBalance: list.totalBalance,
            token: widget.token!,
            id: id!,
          ),
    );
  }

  void removeExpenses(Expense expense) {
    final list = Provider.of<ExpenseProvider>(context, listen: false);
    final expenseIndex = list.expenses.indexOf(expense);
    list.remove(expense);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 3),
        content: Text("data is removed"),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            list.undoRemove(expense, expenseIndex);
          },
        ),
      ),
    );
  }

  void logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Login(onToggleTheme: widget.onToggleTheme),
      ),
    );
  }

  @override
  Widget build(BuildContext content) {
    void _onItemTapped(int index) {
      print(index);
      setState(() {
        _selectedIndex = index;
      });
    }

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    final provider = Provider.of<ExpenseProvider>(context);

    final indexHome = Consumer<ExpenseProvider>(
      builder: (context, ExpenseProvider, child) {
        Widget currentAction;
        if (ExpenseProvider.expenses.isEmpty) {
          currentAction = Center(
            child: Text("No data found, Create some new data"),
          );
        } else {
          currentAction = ExpenseList(
            expenseList: ExpenseProvider.expenses,
            onRemoveExpenses: removeExpenses,
          );
        }
        return Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Chart(expenses: ExpenseProvider.expenses),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Recent History",
                    style: TextStyle(color: textColor, fontSize: 18),
                  ),
                  Spacer(),
                  Text(
                    'Total Balance: ₹${ExpenseProvider.totalBalance.toStringAsFixed(2)}',
                    style: TextStyle(color: textColor, fontSize: 18),
                  ),
                ],
              ),
            ),
            // SizedBox(height: 20),
            Expanded(child: currentAction),
          ],
        );
      },
    );

    final indexAnalysis = ExpensePieChart(
      expenses:
          provider.expenses
              .where((e) => e.type == TrackerType.expense)
              .toList(),
    );

    final indexProfile = Profile(
      username: username,
      email: email,
      logout: logout,
    );

    final List<Widget> pages = [indexHome, indexAnalysis, indexProfile];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Personal Expense Tracker"),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () {
              downloadExpensesAsCSV(
                Provider.of<ExpenseProvider>(context, listen: false).expenses,
              );
            },
          ),
          IconButton(
            icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: pages[_selectedIndex],

      floatingActionButton:
          _selectedIndex == 0
              ? FloatingActionButton(
                onPressed: showAddingForm,
                child: const Icon(Icons.add),
              )
              : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Analysis',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
