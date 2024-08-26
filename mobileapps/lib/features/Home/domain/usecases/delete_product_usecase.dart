import 'package:dio/dio.dart';
import 'package:mobileapps/features/Home/domain/repositories/home_repository.dart';

class DeleteProductUsecase {
  final HomeRepository homeRepository;

  const DeleteProductUsecase(this.homeRepository);

  execute(int id) async {
    return await homeRepository.deleteProduct(id);
  }
}
