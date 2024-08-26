class Product {
  final int id;
  final String name;
  final String desc;
  final int price;
  final String image;
  final String lat;
  final String long;

  Product({
    required this.id,
    required this.name,
    required this.desc,
    required this.price,
    required this.image,
    required this.lat,
    required this.long,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'desc': desc,
      'price': price,
      'image': image,
      'lat': lat,
      'long': long
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      desc: json['desc'],
      price: json['price'],
      image: json['image'],
      lat: json['lat'],
      long: json['long'],
    );
  }
}
