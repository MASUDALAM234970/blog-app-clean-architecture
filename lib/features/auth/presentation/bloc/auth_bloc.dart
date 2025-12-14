import 'package:blog_app/features/auth/domain/entities/user.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;

  AuthBloc({required UserSignUp userSignup})
      : _userSignUp = userSignup,
        super(AuthInitial()) {
    on<SignUpEvent>((event, emit) async {
      emit(AuthLoading());

      final res = await _userSignUp(
        UserSignUpParams(
          name: event.name,
          email: event.email,
          password: event.password,
        ),
      );

      res.fold(
            (failure) => emit(AuthFailure(message: failure.message)),
            (user) => emit(AuthSuccess(user: user)),
      );
    });
  }
}
