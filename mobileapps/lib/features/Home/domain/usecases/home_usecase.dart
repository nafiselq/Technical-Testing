import 'package:dio/dio.dart';
import 'package:mobileapps/features/Home/domain/repositories/home_repository.dart';

class Home {
  final HomeRepository homeRepository;

  const Home(this.homeRepository);

  execute(FormData body) async {
    return await homeRepository.createProduct(body);
  }
}
