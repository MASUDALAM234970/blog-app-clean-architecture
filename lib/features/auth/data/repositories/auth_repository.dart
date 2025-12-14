import 'package:fpdart/fpdart.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../datasources/auth_remote_data_source.dart';
import '../../domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});


  @override
  Future<Either<Failure, String>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final userId = await remoteDataSource.signUpWithEmailPassword(
        name: name,
        email: email,
        password: password,
      );

      return Right(userId);
    } on ServerException catch (e) {
      return Left(ServerException(e.message) as Failure);
    }
  }

  @override
  Future<Either<Failure, String>> loginWithEmailPassword({required String name, required String email, required String password}) {
    // TODO: implement loginWithEmailPassword
    throw UnimplementedError();
  }
}
