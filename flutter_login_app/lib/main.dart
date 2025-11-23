import 'package:flutter/material.dart';
import 'package:flutter_login_app/models/pokemon.dart';
import 'package:flutter_login_app/pages/detail/pokemon_detail_page.dart';
import 'package:flutter_login_app/pages/home/home_page.dart';
import 'package:flutter_login_app/pages/home/pokemon_list/pokemon_list_page.dart';
import 'package:flutter_login_app/pages/login/login_page.dart';

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
        } else if (settings.name == '/detail') {
          return MaterialPageRoute(
            builder: (context) =>
                PokemonDetailPage(pokemon: settings.arguments as Pokemon),
          );
        }
        return null;
      },
    );
  }
}
