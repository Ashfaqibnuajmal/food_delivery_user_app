part of 'auth_bloc_bloc.dart';

@immutable
sealed class AuthBlocEvent {}

class AuthCheckEvent extends AuthBlocEvent {}

class LoginEvent extends AuthBlocEvent {
  final String email;
  final String password;
  LoginEvent({required this.email, required this.password});
}

class RegisterEvent extends AuthBlocEvent {
  final String name;
  final String password;
  final String email;
  final String phone;
  RegisterEvent({
    required this.phone,
    required this.name,
    required this.email,
    required this.password,
  });
}

class GoogleSignInEvent extends AuthBlocEvent {}

class LogoutEvent extends AuthBlocEvent {}
