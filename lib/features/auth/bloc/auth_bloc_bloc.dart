import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_user_app/features/auth/data/services/auth_service.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_bloc_event.dart';
part 'auth_bloc_state.dart';

class AuthBlocBloc extends Bloc<AuthBlocEvent, AuthBlocState> {
  final AuthService authService = AuthService();

  AuthBlocBloc() : super(AuthBlocInitial()) {
    on<AuthCheckEvent>(_authCheck);
    on<LoginEvent>(_login);
    on<RegisterEvent>(_register);
    on<GoogleSignInEvent>(_googleSignIn);
    on<LogoutEvent>(_logout);
  }

  Future<void> _authCheck(
    AuthCheckEvent event,
    Emitter<AuthBlocState> emit,
  ) async {
    final sharedPref = await SharedPreferences.getInstance();
    final _isFirst = sharedPref.getBool('_isFirst') ?? false;
    log('Auth check started');

    try {
      await Future.delayed(Duration(seconds: 3));
      if (!_isFirst) {
        await sharedPref.setBool("_isFirst", true);
        log('Welcome state emitted');
        emit(WelcomeState());
        return;
      } else if (await authService.checkUser()) {
        log('Authenticated state emitted');
        emit(Authenticated(authService.getUserId()!));
      } else {
        log('Unauthenticated state emitted');
        emit(Unauthenticated());
      }
    } on FirebaseAuthException catch (e) {
      log('ErrorAuth state emitted');
      emit(ErrorAuth(e.message.toString()));
    }
  }

  void _login(LoginEvent event, Emitter<AuthBlocState> emit) async {
    log('Login started');
    await Future.delayed(const Duration(seconds: 3));
    log("_loadingstate");
    emit(AuthBlocLoading());
    try {
      final String? user = await authService.signInUser(
        email: event.email,
        password: event.password,
      );
      if (user != null) {
        log('Authenticated state emitted');
        emit(Authenticated(user));
      } else {
        log('Unauthenticated state emitted');
        emit(Unauthenticated());
      }
    } on FirebaseAuthException catch (e) {
      log('Firebase error during login');
      emit(ErrorAuth('Firebase error: ${e.message.toString()}'));
    }
  }

  void _register(RegisterEvent event, Emitter<AuthBlocState> emit) async {
    log('Register started');
    emit(AuthBlocLoading());
    await Future.delayed(const Duration(seconds: 3));
    try {
      final String? user = await authService.registerUser(
        name: event.name,
        email: event.email,
        phone: event.phone,
        password: event.password,
      );
      if (user != null) {
        log('Authenticated state emitted after register');
        emit(Authenticated(user));
      } else {
        log('Unauthenticated state emitted after register');
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(ErrorAuth(e.toString()));
    }
  }

  _googleSignIn(GoogleSignInEvent event, Emitter<AuthBlocState> emit) async {
    try {
      final userId = await authService.googleSignIn();
      emit(Authenticated(userId));
    } catch (e) {
      emit(ErrorAuth(e.toString()));
    }
  }

  _logout(LogoutEvent event, Emitter<AuthBlocState> emit) async {
    try {
      authService.signOut();
      emit(Unauthenticated());
    } catch (e) {
      emit(ErrorAuth(e.toString()));
    }
  }
}
