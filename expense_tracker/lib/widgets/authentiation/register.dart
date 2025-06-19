import 'dart:convert';

import 'package:expense_tracker/widgets/authentiation/login.dart';
import 'package:expense_tracker/widgets/expenses.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  const Register({super.key, required this.onToggleTheme});

  final VoidCallback onToggleTheme;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  void handleRegister() async {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    if (name.text.isEmpty || password.text.isEmpty) {
      showDialog(
        context: context,
        builder:
            (ctx) => AlertDialog(
              title: Text("Invalid Input", style: TextStyle(color: textColor)),
              content: Text(
                "All fields are mandetory",
                style: TextStyle(color: textColor),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text("OK"),
                ),
              ],
            ),
      );
    }
    if (name.text.isNotEmpty &&
        email.text.isNotEmpty &&
        password.text.isNotEmpty) {
      print("valid Input");
      var reqBody = {
        "username": name.text,
        "email": email.text,
        "password": password.text,
      };
      print(reqBody);

      var response = await http.post(
        Uri.parse("http://10.0.2.2:3000/api/users/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody),
      );
      print(response.statusCode);

      if (response.statusCode == 200) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Login(onToggleTheme: widget.onToggleTheme),
          ),
        );
        print("Registration successful");
      } else {
        print("Failed: ${response.body}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 10,
            top: 30,
            right: 10,
            bottom: 10,
          ),
          child: Column(
            children: [
              Text(
                "REGISTER",
                style: TextStyle(color: textColor, fontSize: 20),
              ),
              TextField(
                style: TextStyle(color: textColor),
                controller: name,
                maxLength: 20,
                decoration: InputDecoration(label: Text("Username")),
                keyboardType: TextInputType.text,
              ),
              TextField(
                style: TextStyle(color: textColor),
                controller: email,
                maxLength: 20,
                decoration: InputDecoration(label: Text("Email ID")),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                style: TextStyle(color: textColor),
                controller: password,
                maxLength: 20,
                decoration: InputDecoration(label: Text("Password")),
                keyboardType: TextInputType.text,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(color: textColor),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    Login(onToggleTheme: widget.onToggleTheme),
                          ),
                        );
                      });
                    },
                    child: Text("Login"),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: handleRegister,
                    child: Text("Register"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
