import 'package:blog_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_app/features/auth/data/repositories/auth_repository.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/secrets/app_secrets.dart';
import 'features/auth/domain/repository/auth_repository.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );

  // SupabaseClient
  serviceLocator.registerLazySingleton<SupabaseClient>(
        () => Supabase.instance.client,
  );

  // Initialize Auth module dependencies
  _initAuth();
}

void _initAuth() {
  // Remote Data Source
  serviceLocator.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(
      supabaseClient: serviceLocator<SupabaseClient>(),
    ),
  );

  // Repository
  serviceLocator.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
      remoteDataSource: serviceLocator<AuthRemoteDataSource>(),
    ),
  );

  // Usecase
  serviceLocator.registerFactory<UserSignUp>(
        () => UserSignUp(
      authRepository: serviceLocator<AuthRepository>(),
    ),
  );

  // Bloc
  serviceLocator.registerFactory<AuthBloc>(
        () => AuthBloc(
      userSignup: serviceLocator<UserSignUp>(),
    ),
  );
}
