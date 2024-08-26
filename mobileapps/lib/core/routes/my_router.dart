import 'dart:convert';

import 'package:go_router/go_router.dart';
import 'package:mobileapps/features/Auth/presentation/pages/login_page.dart';
import 'package:mobileapps/features/Home/domain/entities/product.dart';
import 'package:mobileapps/features/Home/presentation/pages/detail_product.dart';
import 'package:mobileapps/features/Home/presentation/pages/form_product.dart';
import 'package:mobileapps/features/Home/presentation/pages/home_page.dart';

class MyRouter {
  get router => GoRouter(
        initialLocation: '/login',
        routes: [
          GoRoute(
            path: "/login",
            name: "login",
            pageBuilder: (context, state) => const NoTransitionPage(
              child: LoginPage(),
            ),
          ),
          GoRoute(
            path: "/",
            name: "home",
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomePage(),
            ),
            routes: [
              GoRoute(
                path: 'form',
                name: 'formProduct',
                pageBuilder: (context, state) {
                  final type = state.uri.queryParameters['type'];
                  final product = state.uri.queryParameters['data'];
                  Product? productData;
                  if (product != null) {
                    productData = Product.fromJson(jsonDecode(product));
                  }
                  return NoTransitionPage(
                      child: FormProductPage(
                    type: type.toString(),
                    product: productData,
                  ));
                },
              ),
              GoRoute(
                path: 'details',
                name: 'detailProduct',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: DetailProductPage(),
                ),
              )
            ],
          ),
        ],
      );
}
