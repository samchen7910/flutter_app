import 'package:flutter/material.dart';
import 'package:flutter_login_app/home/home_page.dart';
import 'package:flutter_login_app/login/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      onGenerateRoute: (settings) {
        if (settings.name == '/login') {
          return MaterialPageRoute(builder: (context) => const LoginPage());
        } else if (settings.name == '/home') {
          return MaterialPageRoute(
            builder: (context) =>
                HomePage(username: settings.arguments as String),
          );
        }
        return null;
      },
    );
  }
}
