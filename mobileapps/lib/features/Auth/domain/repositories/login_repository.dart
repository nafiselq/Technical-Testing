import 'package:dartz/dartz.dart';
import 'package:mobileapps/core/error/failure.dart';

import '../entities/user.dart';

abstract class LoginRepository {
  Future<Either<Failure, User>> login(String email, String password);
}
