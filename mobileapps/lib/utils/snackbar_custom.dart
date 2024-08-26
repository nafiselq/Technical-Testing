import 'package:flutter/material.dart';

void showSnackbar(String message, BuildContext context, Color bgColor) {
  final snackBar = SnackBar(
    backgroundColor: bgColor,
    content: Text(
      message,
      style: const TextStyle(color: Colors.white),
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
