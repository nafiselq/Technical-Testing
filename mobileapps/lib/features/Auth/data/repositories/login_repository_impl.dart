import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:mobileapps/core/error/failure.dart';
import 'package:mobileapps/features/Auth/data/datasources/remote_datasource.dart';
import 'package:mobileapps/features/Auth/data/models/user_model.dart';
import 'package:mobileapps/features/Auth/domain/entities/user.dart';
import 'package:mobileapps/features/Auth/domain/repositories/login_repository.dart';

class LoginRepositoryImpl extends LoginRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  LoginRepositoryImpl({required this.authRemoteDataSource});

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final List<ConnectivityResult> connectivityResult =
          await (Connectivity().checkConnectivity());

      if (connectivityResult.contains(ConnectivityResult.none)) {
        //Redirect page no internet connection
      } else {
        Either<Failure, User> userData =
            await authRemoteDataSource.login(email, password);

        return userData.fold(
          (l) {
            return Left(Failure(statusCode: l.statusCode, message: l.message));
          },
          (r) {
            return Right(r);
            // return Right(r);
          },
        );
      }
    } catch (e) {
      print("ini error : $e");
      return Left(Failure(statusCode: 500, message: "Internal Server Error"));
    }

    // TODO: implement login
    throw UnimplementedError();
  }
}
