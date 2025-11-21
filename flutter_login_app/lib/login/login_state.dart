import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();
  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginFailed extends LoginState {
  final String error = 'Login failed';
}

class LoginSuccess extends LoginState {
  final String username;
  const LoginSuccess(this.username);
  @override
  List<Object> get props => [username];
}
