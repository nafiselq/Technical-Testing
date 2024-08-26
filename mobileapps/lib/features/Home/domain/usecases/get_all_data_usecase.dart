import 'package:dartz/dartz.dart';
import 'package:mobileapps/core/error/failure.dart';
import 'package:mobileapps/features/Home/domain/entities/product.dart';
import 'package:mobileapps/features/Home/domain/repositories/home_repository.dart';

class GetAllProduct {
  final HomeRepository homeRepository;

  GetAllProduct(this.homeRepository);

  Future<Either<Failure, List<Product>>> execute(int page) async {
    return await homeRepository.getListData(page);
  }
}
