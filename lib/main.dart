import 'package:flutter/material.dart';
import 'package:karim_taha_task/core/colors.dart';
import 'package:karim_taha_task/core/di.dart';
import 'package:karim_taha_task/presentation/view/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencyInjection(); // Initialize DI

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Orders Overview',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Roboto',
        primaryColor: MainColors.primary,
        scaffoldBackgroundColor: MainColors.snow,
        cardColor: Colors.grey[850],
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: MainColors.primary,
          ),
        ),
      ),
      home: MainScreen(),
    );
  }
}
