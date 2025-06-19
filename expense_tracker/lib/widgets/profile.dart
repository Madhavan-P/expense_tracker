import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({
    super.key,
    required this.username,
    required this.email,
    required this.logout,
  });

  final username;
  final email;
  final void Function(BuildContext context) logout;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: Row(
                children: [
                  Text("Username: ", style: TextStyle(color: textColor)),
                  SizedBox(width: 20),
                  Text(widget.username, style: TextStyle(color: textColor)),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: Row(
                children: [
                  Text("Email: ", style: TextStyle(color: textColor)),
                  SizedBox(width: 50),
                  Text(widget.email, style: TextStyle(color: textColor)),
                ],
              ),
            ),
            SizedBox(height: 50),
            Container(
              width: 300,
              child: ElevatedButton(
                onPressed: () => widget.logout(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text("Logout"), Icon(Icons.logout)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
