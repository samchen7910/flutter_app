import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_app/components/my_button.dart';
import 'package:flutter_login_app/components/my_textfield.dart';
import 'package:flutter_login_app/login/login_controller.dart';
import 'package:flutter_login_app/login/login_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernamController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    usernamController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: BlocProvider(
        create: (context) {
          final controller = LoginController();
          return controller;
        },
        child: BlocConsumer<LoginController, LoginState>(
          builder: (context, state) {
            if (state is LoginLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return SafeArea(
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      const Icon(Icons.lock, size: 100),
                      const SizedBox(height: 50),

                      Text(
                        'Welcome to LoginApp',
                        style: TextStyle(color: Colors.grey[700], fontSize: 16),
                      ),

                      const SizedBox(height: 25),
                      // email
                      MyTextfield(
                        controller: usernamController,
                        hintText: 'Username',
                        obscureText: false,
                      ),
                      const SizedBox(height: 12),
                      // password
                      MyTextfield(
                        controller: passwordController,
                        hintText: 'Password',
                        obscureText: true,
                      ),

                      const SizedBox(height: 25),

                      MyButton(
                        onTap: () {
                          context.read<LoginController>().login(
                            usernamController.text.trim(),
                            passwordController.text.trim(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            }
          },
          listener: (BuildContext context, LoginState state) {
            if (state is LoginSuccess) {
              Navigator.pushNamed(
                context,
                '/home',
                arguments: usernamController.text,
              );
            }
          },
        ),
      ),
    );
  }
}
