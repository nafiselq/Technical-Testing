import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobileapps/core/error/failure.dart';
import 'package:mobileapps/features/Auth/domain/entities/user.dart';
import 'package:mobileapps/features/Home/data/models/product_model.dart';
import 'package:mobileapps/features/Home/domain/entities/product.dart';
import 'package:mobileapps/features/Home/domain/usecases/delete_product_usecase.dart';
import 'package:mobileapps/features/Home/domain/usecases/get_all_data_usecase.dart';
import 'package:mobileapps/features/Home/domain/usecases/home_usecase.dart';
import 'package:mobileapps/features/Home/domain/usecases/update_product_usecase.dart';
import '../../../../utils/result_state.dart';

class HomeProvider extends ChangeNotifier {
  final Home homeCase;
  final GetAllProduct getAllProduct;
  final UpdateProductUsecase updateProductUsecase;
  final DeleteProductUsecase deleteProductUsecase;
  HomeProvider({
    required this.homeCase,
    required this.getAllProduct,
    required this.updateProductUsecase,
    required this.deleteProductUsecase,
  });

  String? _message;
  String? get message => _message;
  bool? _status;
  bool? get status => _status;
  ResultState? _state;
  ResultState? get state => _state;
  final List<Product> _product = [];
  List<Product> get product => _product;

  int _currentPage = 1;
  bool _hasMoreData = true;
  bool get hasMoreData => _hasMoreData;

  Future<bool> createProduct(FormData body) async {
    _state = ResultState.Loading;
    notifyListeners();

    var data = await homeCase.execute(body);

    if (data) {
      _state = ResultState.HasData;
      notifyListeners();

      return true;
    } else {
      _state = ResultState.Error;
      _message = 'Terjadi Kesalahan, Silahkan coba lagi';
      notifyListeners();

      return false;
    }
  }

  Future<void> getAllProducts({bool reset = false}) async {
    if (reset) {
      _product.clear();
      _currentPage = 1;
      _hasMoreData = true;
      _message = null;
      _state = null;
      notifyListeners();
    }
    if (_state == ResultState.Loading || !_hasMoreData) return;

    _state = ResultState.Loading;
    notifyListeners();

    Either<Failure, List<Product>> data =
        await getAllProduct.execute(_currentPage);

    data.fold((left) {
      _state = ResultState.Error;
      _message = 'Failed to load products';
      _hasMoreData = false;
      notifyListeners();
    }, (right) {
      if (right.isEmpty) {
        _hasMoreData = false;
        if (_product.isEmpty) {
          _state = ResultState.NoData;
        } else {
          _state = ResultState.HasData;
        }
      } else {
        _product.addAll(right);
        _currentPage++;
        _state = ResultState.HasData;
      }
      notifyListeners();
    });
  }

  Future<bool> updateProduct(FormData body, int id) async {
    _state = ResultState.Loading;
    notifyListeners();

    var data = await updateProductUsecase.execute(body, id);

    if (data) {
      _state = ResultState.HasData;
      notifyListeners();

      return true;
    } else {
      _state = ResultState.Error;
      _message = 'Terjadi Kesalahan, Silahkan coba lagi';
      notifyListeners();

      return false;
    }
  }

  Future<bool> deleteProduct(int id) async {
    _state = ResultState.Loading;
    notifyListeners();

    var data = await deleteProductUsecase.execute(id);

    if (data) {
      _state = ResultState.HasData;
      notifyListeners();

      return true;
    } else {
      _state = ResultState.Error;
      _message = 'Terjadi Kesalahan, Silahkan coba lagi';
      notifyListeners();

      return false;
    }
  }
}
