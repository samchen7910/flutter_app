import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_app/home/home_controller.dart';
import 'package:flutter_login_app/home/home_state.dart';

import 'user_list/user_list_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.username});

  final String username;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeController()..fetchData(),
      child: PokemonListPage(username: username),
    );
  }
}
