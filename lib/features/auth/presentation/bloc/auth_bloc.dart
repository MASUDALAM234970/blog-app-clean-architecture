// import 'package:blog_app/core/common/cubits/app_user_cubit.dart';
// import 'package:blog_app/features/auth/domain/usecases/current_user.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter/material.dart';
// import '../../../../core/usecase/usecase.dart';
// import '../../domain/usecases/user_sign_up.dart';
// import '../../domain/usecases/user_login.dart';
// import '../../../../core/common/entities/user.dart';
//
// part 'auth_event.dart';
// part 'auth_state.dart';
//
// class AuthBloc extends Bloc<AuthEvent, AuthState> {
//   final UserSignUp _userSignUp;
//   final UserLogin _userLogin;
//   final CurrentUser _currentUser;
//   final AppUserCubit _appUserCubit;
//
//   AuthBloc({
//     required UserSignUp userSignUp,
//     required UserLogin userLogin,
//     required CurrentUser currentUser,
//     required AppUserCubit appUserCubit// ✅ add this
//   })  : _userSignUp = userSignUp,
//         _userLogin = userLogin,
//         _currentUser = currentUser,
//         _appUserCubit = appUserCubit,
//         super(AuthInitial()) {
//     on<AuthSignUp>(_onAuthSignUp);
//     on<AuthLogin>(_onAuthLogin);
//     on<AuthIsUserLoggedIn>(_isUserLoggedIn);
//   }
//
//   void _isUserLoggedIn(
//       AuthIsUserLoggedIn event,
//       Emitter<AuthState> emit,
//       ) async {
//     emit(AuthLoading());
//
//     final result = await _currentUser(NoParams());
//
//     result.fold(
//           (failure) => emit(AuthFailure(message: failure.message)),
//           (user) {
//         debugPrint(user.email);
//         emit(AuthSuccess(user: user));
//       },
//     );
//
//   }
//
//   void _onAuthSignUp(
//       AuthSignUp event,
//       Emitter<AuthState> emit,
//       ) async {
//     emit(AuthLoading());
//
//     final result = await _userSignUp(
//       UserSignUpParams(
//         name: event.name,
//         email: event.email,
//         password: event.password,
//       ),
//     );
//
//     result.fold(
//           (failure) => emit(AuthFailure(message: failure.message)),
//           (user) => emit(AuthSuccess(user: user)),
//     );
//   }
//
//   void _onAuthLogin(
//       AuthLogin event,
//       Emitter<AuthState> emit,
//       ) async {
//     emit(AuthLoading());
//
//     final result = await _userLogin(
//       UserLoginParams(
//         email: event.email,
//         password: event.password,
//       ),
//     );
//
//     result.fold(
//           (failure) => emit(AuthFailure(message: failure.message)),
//           (user) => emit(AuthSuccess(user: user)),
//     );
//   }
//
//   void _emitAuthSuccess(
//       User user,
//       Emitter<AuthState> emit,
//       ) {
//     _appUserCubit.updateUser(user);
//     emit(AuthSuccess( user:user));
//   }
//
//
// }


import 'package:blog_app/core/common/cubits/app_user_cubit.dart';
import 'package:blog_app/features/auth/domain/usecases/current_user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/usecases/user_sign_up.dart';
import '../../domain/usecases/user_login.dart';
import '../../../../core/common/entities/user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogin userLogin,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
  })  : _userSignUp = userSignUp,
        _userLogin = userLogin,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthIsUserLoggedIn>(_onIsUserLoggedIn);
  }

  // 🔹 CHECK CURRENT USER (APP START)
  Future<void> _onIsUserLoggedIn(
      AuthIsUserLoggedIn event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());

    final result = await _currentUser(NoParams());

    result.fold(
          (failure) {
        // user not logged in → clear global user
        _appUserCubit.clearUser();
        emit(AuthInitial());
      },
          (user) {
        _emitAuthSuccess(user, emit);
      },
    );
  }

  // 🔹 SIGN UP
  Future<void> _onAuthSignUp(
      AuthSignUp event,
      Emitter<AuthState> emit,
      ) async {
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
          (user) => _emitAuthSuccess(user, emit),
    );
  }

  // 🔹 LOGIN
  Future<void> _onAuthLogin(
      AuthLogin event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());

    final result = await _userLogin(
      UserLoginParams(
        email: event.email,
        password: event.password,
      ),
    );

    result.fold(
          (failure) => emit(AuthFailure(message: failure.message)),
          (user) => _emitAuthSuccess(user, emit),
    );
  }

  // 🔹 COMMON SUCCESS HANDLER (🔥 MOST IMPORTANT)
  void _emitAuthSuccess(
      User user,
      Emitter<AuthState> emit,
      ) {
    _appUserCubit.updateUser(user); // ✅ update global user
    emit(AuthSuccess(user: user));
  }
}
