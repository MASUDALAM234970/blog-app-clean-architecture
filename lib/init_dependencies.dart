import 'package:blog_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_app/features/auth/data/repositories/auth_repository.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/secrets/app_secrets.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // SUPABASE MUST INITIALIZE FIRST
  await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );

  // SupabaseClient register
  serviceLocator.registerLazySingleton<SupabaseClient>(
        () => Supabase.instance.client,
  );

  // Init all Auth-related DI
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
  serviceLocator.registerLazySingleton(
        () => AuthRepositoryImpl(
      remoteDataSource: serviceLocator<AuthRemoteDataSource>(),
    ),
  );

  // Usecase
  serviceLocator.registerFactory(
        () => UserSignUp(
      authRepository: serviceLocator(),
    ),
  );

  // Bloc
  serviceLocator.registerFactory(
        () => AuthBloc(
      userSignup: serviceLocator(),
    ),
  );
}
