import 'package:expense_tracker/widgets/expenses.dart';
import 'package:expense_tracker/widgets/initialPage.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    required this.token,
    super.key,
    required this.onToggleTheme,
  });
  final token;
  final VoidCallback onToggleTheme;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (ctx) =>
                  widget.token != null && !JwtDecoder.isExpired(widget.token)
                      ? Expenses(
                        token: widget.token,
                        onToggleTheme: widget.onToggleTheme,
                      )
                      : InitialPage(onToggleTheme: widget.onToggleTheme),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wallet, size: 80, color: Colors.purple),
            SizedBox(height: 16),
            Text(
              'Expense Tracker',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 10),
            CircularProgressIndicator(color: Colors.purple),
          ],
        ),
      ),
    );
  }
}
