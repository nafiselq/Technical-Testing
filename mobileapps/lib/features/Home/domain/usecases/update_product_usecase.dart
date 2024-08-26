import 'package:dio/dio.dart';
import 'package:mobileapps/features/Home/domain/repositories/home_repository.dart';

class UpdateProductUsecase {
  final HomeRepository homeRepository;

  const UpdateProductUsecase(this.homeRepository);

  execute(FormData body, int id) async {
    return await homeRepository.updateProduct(body, id);
  }
}
