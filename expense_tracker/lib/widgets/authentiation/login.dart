import 'dart:convert';
import 'package:expense_tracker/widgets/authentiation/register.dart';
import 'package:expense_tracker/widgets/expenses.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key, required this.onToggleTheme});
  final VoidCallback onToggleTheme;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final name = TextEditingController();
  final password = TextEditingController();
  // late SharedPreferences prefs;
  bool _isLoading = false;

  // @override
  // void initState() {
  //   super.initState();
  //   _initSharedPrefs();
  // }

  // void _initSharedPrefs() async {
  //   prefs = await SharedPreferences.getInstance();
  // }

  void onSubmitHandler() async {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    // if (prefs == null) {
    //   await _initSharedPrefs();
    // }

    if (name.text.isEmpty || password.text.isEmpty) {
      showDialog(
        context: context,
        builder:
            (ctx) => AlertDialog(
              title: Text("Invalid Input", style: TextStyle(color: textColor)),
              content: Text(
                "All fields are mandatory",
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
      return;
    }

    setState(() {
      _isLoading = true;
    });

    var reqBody = {"username": name.text, "password": password.text};

    try {
      final prefs = await SharedPreferences.getInstance();
      var response = await http.post(
        Uri.parse("http://10.0.2.2:3000/api/users/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody),
      );
      print(response.statusCode);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
        print("✅ Login successful: ${data['accessToken']}");
        var myToken = data['accessToken'];
        prefs.setString('token', myToken);

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder:
                (context) => Expenses(
                  onToggleTheme: widget.onToggleTheme,
                  token: myToken,
                ),
          ),
        );
      } else {
        print("❌ Login failed: ${response.body}");
        showDialog(
          context: context,
          builder:
              (ctx) => AlertDialog(
                title: Text("Login Failed", style: TextStyle(color: textColor)),
                content: Text(
                  "Invalid Credentials",
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
    } catch (e) {
      print("❌ Error: $e");
      showDialog(
        context: context,
        builder:
            (ctx) => AlertDialog(
              title: Text("Error", style: TextStyle(color: textColor)),
              content: Text(
                "Something went wrong. Please try again.",
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
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
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
              Text("LOGIN", style: TextStyle(color: textColor, fontSize: 20)),
              TextField(
                style: TextStyle(color: textColor),
                controller: name,
                maxLength: 20,
                decoration: const InputDecoration(labelText: "Username"),
                keyboardType: TextInputType.text,
              ),
              TextField(
                style: TextStyle(color: textColor),
                controller: password,
                maxLength: 20,
                decoration: const InputDecoration(labelText: "Password"),
                keyboardType: TextInputType.text,
                obscureText: true,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(color: textColor),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  Register(onToggleTheme: widget.onToggleTheme),
                        ),
                      );
                    },
                    child: const Text("Register"),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: _isLoading ? null : onSubmitHandler,
                    child:
                        _isLoading
                            ? const CircularProgressIndicator()
                            : const Text("Login"),
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
