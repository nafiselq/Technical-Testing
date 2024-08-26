import 'package:mobileapps/features/Auth/domain/entities/user.dart';
import 'package:mobileapps/features/Home/domain/entities/product.dart';

class ProductModel extends Product {
  ProductModel({
    required super.id,
    required super.name,
    required super.desc,
    required super.price,
    required super.image,
    required super.lat,
    required super.long,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      desc: json['desc'],
      price: json['price'],
      image: json['image'],
      lat: json['lat'],
      long: json['long'],
    );
  }

  static List<ProductModel> fromJsonList(List data) {
    if (data.isEmpty) return [];

    return data
        .map((singleDataProduct) => ProductModel.fromJson(singleDataProduct))
        .toList();
  }
}
