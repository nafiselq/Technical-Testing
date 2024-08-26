import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:mobileapps/core/error/failure.dart';
import 'package:mobileapps/features/Auth/domain/entities/user.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../../../utils/result_state.dart';

class LoginProvider extends ChangeNotifier {
  final Login loginCase;
  LoginProvider({required this.loginCase});

  User? _user;
  User? get user => _user;
  String? _message;
  String? get message => _message;
  ResultState? _state;
  ResultState? get state => _state;

  Future<dynamic> loginProvider(String email, String password) async {
    _state = ResultState.Loading;
    notifyListeners();

    Either<Failure, User> responseLogin =
        await loginCase.execute(email, password);

    responseLogin.fold((left) {
      _state = ResultState.Error;
      _message = left.message;
      notifyListeners();
    }, (right) {
      _state = ResultState.HasData;
      notifyListeners();
    });
  }
}
