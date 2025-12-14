import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl  implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;
  AuthRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    // Simulate network call
     try{

      final response =await supabaseClient.auth.signUp(
      email: email,
      password: password,

        data: {'name': name},

       );
      if(response.user==null){
        throw ServerException('User is null');
      }
      return UserModel.fromJson(response.user!.toJson());

  } catch(e){
    throw ServerException(e.toString());
  }

  }

  @override
  Future<UserModel> loginWithEmailPassword({required String email, required String password}) {
    // TODO: implement loginWithEmailPassword
    throw UnimplementedError();
  }

  // @override
  // Future<String> loginWithEmailPassword({
  //   required String email,
  //   required String password,
  // }) async {
  //   // Simulate network call
  //   await Future.delayed(const Duration(seconds: 2));
  //   // Return a mock user ID
  //   return 'user_id_123';
  // }
}