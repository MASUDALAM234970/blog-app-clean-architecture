import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../domain/usecases/user_sign_up.dart';
import '../../domain/usecases/user_login.dart';
import '../../domain/entities/user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogin userLogin,
  })  : _userSignUp = userSignUp,
        _userLogin = userLogin,
        super(AuthInitial()) {
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
  }

  void _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await _userSignUp(
      UserSignUpParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );

    result.fold(
          (failure) => emit(AuthFailure(message: failure.message)),
          (user) => emit(AuthSuccess(user: user)),
    );
  }

  void _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await _userLogin(
      UserLoginParams(
        email: event.email,
        password: event.password,
      ),
    );

    result.fold(
          (failure) => emit(AuthFailure(message: failure.message)),
          (user) => emit(AuthSuccess(user: user)),
    );
  }
}
