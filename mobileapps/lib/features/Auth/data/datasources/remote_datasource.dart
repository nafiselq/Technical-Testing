import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/services/api_service.dart';
import '../models/user_model.dart';
import '../../domain/entities/user.dart';

abstract class AuthRemoteDataSource {
  Future<Either<Failure, User>> login(String email, String password);
}

class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  Dio dio = ApiServices().launch();
  final box = GetStorage();
  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    final response = await dio.post(
      'http://192.168.18.7:2000/api/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      String token = response.data['accessToken'];
      box.write("token", token);
      return Right(UserModel.fromJson(response.data['data']));
    } else {
      return Left(Failure.fromJson(response.data));
    }
  }
}
