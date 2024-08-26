import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:mobileapps/core/error/failure.dart';
import 'package:mobileapps/features/Home/domain/entities/product.dart';

abstract class HomeRepository {
  createProduct(FormData data);
  Future<Either<Failure, List<Product>>> getListData(int page);
  updateProduct(FormData data, int id);
  deleteProduct(int id);
}
