import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:mobileapps/features/Home/data/models/product_model.dart';
import 'package:mobileapps/features/Home/domain/entities/product.dart';
import 'package:mobileapps/features/Home/presentation/providers/home_provider.dart';
import 'package:mobileapps/features/Home/presentation/widgets/item_product.dart';
import 'package:mobileapps/utils/result_state.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ScrollController _scrollController;
  late HomeProvider _homeProvider;
  final box = GetStorage();

  void _addProduct() {
    context.goNamed('formProduct', queryParameters: {'type': 'Add'});
  }

  void _editProduct(Product product) {
    String productJson = jsonEncode(product.toJson());
    context.goNamed('formProduct',
        queryParameters: {'type': 'Edit', 'data': productJson});
  }

  void _deleteProduct(int id) async {
    await _homeProvider.deleteProduct(id);
    _refreshProducts();
  }

  void _logout() {
    box.remove('token');
    context.pushNamed('login');
  }

  void onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      _homeProvider.getAllProducts();
    }
  }

  Future<void> _refreshProducts() async {
    // Reset the provider state before fetching data
    await _homeProvider.getAllProducts(reset: true);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(onScroll);
    _homeProvider = Provider.of<HomeProvider>(context, listen: false);

    Future.microtask(() => context.read<HomeProvider>().getAllProducts());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        leading: IconButton(
          icon: const Icon(Icons.add),
          onPressed: _addProduct,
        ),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Consumer<HomeProvider>(
        builder: (context, provider, _) {
          if (provider.state == ResultState.Loading) {
            return Center(child: CircularProgressIndicator());
          } else if (provider.state == ResultState.NoData) {
            return Center(child: Text("Data empty"));
          }
          return RefreshIndicator(
            onRefresh: _refreshProducts,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: provider.product.length + 1,
              itemBuilder: (context, index) {
                if (index == provider.product.length) {
                  return provider.hasMoreData && provider.product.length > 10
                      ? Center(child: CircularProgressIndicator())
                      : SizedBox.shrink();
                }
                return ItemProduct(
                  editButton: () {
                    _editProduct(provider.product[index]);
                  },
                  deleteButton: () {
                    _deleteProduct(provider.product[index].id);
                  },
                  product: provider.product[index],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
