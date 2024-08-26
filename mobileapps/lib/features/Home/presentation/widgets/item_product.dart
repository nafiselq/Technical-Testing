import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobileapps/features/Home/domain/entities/product.dart';

// ignore: must_be_immutable
class ItemProduct extends StatelessWidget {
  Function() editButton;
  Function() deleteButton;
  Product product;
  ItemProduct(
      {super.key,
      required this.editButton,
      required this.deleteButton,
      required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          Container(
            height: 130,
            width: 130,
            color: Colors.red,
            child: Image.network(
              product.image,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product.name),
              const SizedBox(height: 10),
              Text(product.desc),
              const SizedBox(height: 5),
              Text(product.price.toString()),
              const SizedBox(height: 2),
              Text("Lat : ${product.lat}"),
              Text("Long : ${product.long}"),
            ],
          ),
          const Spacer(),
          Column(
            children: [
              IconButton(onPressed: editButton, icon: Icon(Icons.edit)),
              IconButton(onPressed: deleteButton, icon: Icon(Icons.delete)),
            ],
          )
        ],
      ),
    );
  }
}
