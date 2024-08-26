import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobileapps/features/Home/data/models/product_model.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/services/api_service.dart';

abstract class HomeDataResource {
  createProduct(FormData body);
  updateProduct(FormData body, int id);
  getAllProdcut(int page);
  deleteProduct(int id);
}

class HomeRemoteDataSourceImpl extends HomeDataResource {
  Dio dio = ApiServices().launch();
  final box = GetStorage();
  @override
  Future<bool> createProduct(FormData body) async {
    Response response = await dio.post(
      'http://192.168.18.7:2000/api/products',
      data: body,
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<List<ProductModel>> getAllProdcut(int page) async {
    Response response = await dio
        .get('http://192.168.18.7:2000/api/products?search=' '&page=$page');

    print("ini response : $response");

    if (response.statusCode == 200) {
      return ProductModel.fromJsonList(response.data['data']);
    } else {
      return [];
    }
  }

  @override
  updateProduct(FormData body, int id) async {
    Response response = await dio.put(
      'http://192.168.18.7:2000/api/products/$id',
      data: body,
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  @override
  deleteProduct(int id) async {
    Response response =
        await dio.delete('http://192.168.18.7:2000/api/products/$id');

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
