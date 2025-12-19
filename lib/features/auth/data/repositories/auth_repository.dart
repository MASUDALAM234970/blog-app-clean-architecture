import 'package:blog_app/core/common/entities/user.dart';
import 'package:fpdart/fpdart.dart';


import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../datasources/auth_remote_data_source.dart';
import '../../domain/repository/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});


  @override
  Future<Either<Failure, User>> CurrentUser() async{
    try {
      final user = await remoteDataSource.getCurrentUserData();
      if (user == null) {
        return left(Failure('No user logged in'));
      }
      return Right(user);
    } on sb.AuthException catch (e) {
      return Left(Failure(e.message));
    }
    on ServerException catch (e) {
      return Left(Failure(e.message));
    }

  }




  @override
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
      return await _getUser(() => remoteDataSource.signUpWithEmailPassword(
        name: name,
        email: email,
        password: password,
      ));
  }

  @override
  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.loginWithEmailPassword(
        email: email,
        password: password,
      );

      return Right(user);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  Future<Either<Failure, User>> _getUser(
      Future<User> Function() fn,
      ) async {
    try{
      final user = await fn();
      return Right(user);
    } on sb.AuthException catch (e) {
      return Left(Failure(e.message));
    }
    on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }





}
