import 'package:mobileapps/features/Auth/domain/repositories/login_repository.dart';

class Login {
  final LoginRepository loginRepository;

  const Login(this.loginRepository);

  execute(String email, String password) async {
    return await loginRepository.login(email, password);
  }
}
