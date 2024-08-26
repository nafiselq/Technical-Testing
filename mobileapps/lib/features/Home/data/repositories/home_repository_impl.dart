import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/src/form_data.dart';
import 'package:mobileapps/core/error/failure.dart';
import 'package:mobileapps/features/Home/data/datasources/remote_datasource.dart';
import 'package:mobileapps/features/Home/data/models/product_model.dart';
import 'package:mobileapps/features/Home/domain/entities/product.dart';
import 'package:mobileapps/features/Home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl extends HomeRepository {
  final HomeDataResource homeDataResource;
  HomeRepositoryImpl({required this.homeDataResource});

  @override
  Future<bool> createProduct(FormData data) async {
    try {
      var res = await homeDataResource.createProduct(data);

      if (res) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getListData(int page) async {
    try {
      List<ProductModel> data = await homeDataResource.getAllProdcut(page);

      if (data.isEmpty) {
        return Left(Failure(statusCode: 404, message: 'List Not Found'));
      }

      return Right(data);
    } catch (e) {
      return Left(Failure(statusCode: 404, message: e.toString()));
    }
  }

  @override
  updateProduct(FormData data, int id) async {
    try {
      var res = await homeDataResource.updateProduct(data, id);

      if (res) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  deleteProduct(int id) async {
    try {
      var res = await homeDataResource.deleteProduct(id);

      if (res) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
