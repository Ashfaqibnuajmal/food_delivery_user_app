part of 'auth_bloc_bloc.dart';

@immutable
sealed class AuthBlocState {}

final class AuthBlocInitial extends AuthBlocState {}

final class AuthBlocLoading extends AuthBlocState {}

final class WelcomeState extends AuthBlocState {}

final class Authenticated extends AuthBlocState {
  final String authenticated;
  Authenticated(this.authenticated);
}

final class ErrorAuth extends AuthBlocState {
  final String error;
  ErrorAuth(this.error);
}

final class Unauthenticated extends AuthBlocState {}
