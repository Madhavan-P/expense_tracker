import 'package:expense_tracker/model/expenseProvider.dart';
import 'package:expense_tracker/widgets/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

var KcolorSchema = ColorScheme.fromSeed(
  seedColor: Color.fromARGB(255, 96, 59, 181),
);
var KdarkColorSchema = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: Color.fromARGB(255, 5, 99, 125),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(MyApp(token: prefs.getString('token')));
}

class MyApp extends StatefulWidget {
  const MyApp({required this.token, super.key});

  final token;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode themeModeData = ThemeMode.dark;
  void toggleTheme() {
    setState(() {
      print('Current Theme : ${themeModeData}');
      themeModeData =
          themeModeData == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
    print('Switched Theme : ${themeModeData}');
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ExpenseProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        darkTheme: ThemeData.dark().copyWith(
          colorScheme: KdarkColorSchema,
          cardTheme: CardThemeData().copyWith(
            color: KdarkColorSchema.secondaryContainer,
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: KdarkColorSchema.primaryContainer,
              foregroundColor: KdarkColorSchema.onPrimaryContainer,
            ),
          ),
          textTheme: ThemeData().textTheme.copyWith(
            titleLarge: TextStyle(
              fontWeight: FontWeight.bold,
              color: KdarkColorSchema.onSecondaryContainer,
              fontSize: 15,
            ),
          ),
        ),
        theme: ThemeData().copyWith(
          useMaterial3: true,
          colorScheme: KcolorSchema,
          appBarTheme: AppBarTheme().copyWith(
            backgroundColor: KcolorSchema.onPrimaryContainer,
            foregroundColor: KcolorSchema.primaryContainer,
          ),
          cardTheme: CardThemeData().copyWith(
            color: KcolorSchema.secondaryContainer,
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: KcolorSchema.primaryContainer,
            ),
          ),
          textTheme: ThemeData().textTheme.copyWith(
            titleLarge: TextStyle(
              fontWeight: FontWeight.bold,
              color: KcolorSchema.onSecondaryContainer,
              fontSize: 15,
            ),
          ),
          // scaffoldBackgroundColor: Color.fromARGB(255, 220, 189, 252),
        ),
        themeMode: themeModeData,
        home: SplashScreen(onToggleTheme: toggleTheme, token: widget.token),
      ),
    );
  }
}
