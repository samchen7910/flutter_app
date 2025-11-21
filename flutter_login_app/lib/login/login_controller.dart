import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_app/login/login_state.dart';

class LoginController extends Cubit<LoginState> {
  LoginController() : super(LoginInitial());

  login(String username, String password) async {
    emit(LoginLoading());

    await Future.delayed(const Duration(seconds: 1));

    emit(LoginSuccess(username));
  }
}
