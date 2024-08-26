import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/product.dart';
import '../providers/home_provider.dart';
import '../../../../utils/result_state.dart';
import '../../../../utils/snackbar_custom.dart';
import 'package:provider/provider.dart';

class FormProductPage extends StatefulWidget {
  final String type;
  final Product? product;
  const FormProductPage({super.key, required this.type, this.product});

  @override
  State<FormProductPage> createState() => _FormProductPageState();
}

class _FormProductPageState extends State<FormProductPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameProduct = TextEditingController();
  TextEditingController descProduct = TextEditingController();
  TextEditingController priceProduct = TextEditingController();
  TextEditingController lat = TextEditingController();
  TextEditingController long = TextEditingController();
  File? _image;
  final imagePicker = ImagePicker();
  late HomeProvider _homeProvider;
  String? _initialImageUrl;

  Future getImage() async {
    final image = await imagePicker.pickImage(source: ImageSource.camera);
    Position position = await _determinePosition();

    print("${position.latitude} ${position.longitude}");

    setState(() {
      _image = File(image!.path);
      lat.text = position.latitude.toString();
      long.text = position.longitude.toString();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initDataForm();
    _homeProvider = Provider.of<HomeProvider>(context, listen: false);
  }

  initDataForm() {
    nameProduct.text = widget.product?.name ?? '';
    descProduct.text = widget.product?.desc ?? '';
    priceProduct.text = widget.product?.price.toString() ?? '';
    lat.text = widget.product?.lat ?? '';
    long.text = widget.product?.long ?? '';
    _initialImageUrl = widget
        .product?.image; // Assuming your Product entity has an image field
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void submit(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      try {
        HomeProvider homeProvider =
            Provider.of<HomeProvider>(context, listen: false);

        if (widget.type == 'Add') {
          FormData formData = FormData.fromMap({
            "name": nameProduct.text,
            "desc": descProduct.text,
            "price": priceProduct.text,
            "lat": lat.text,
            "long": long.text,
            "image": await MultipartFile.fromFile(
              _image!.path,
              filename: _image!.path.split('/').last,
            ),
          });

          var response = await homeProvider.createProduct(formData);
          if (response) {
            showSnackbar("Create Product Successfully", context, Colors.green);
            await _homeProvider.getAllProducts(reset: true);
            context.pop();
          } else {
            showSnackbar("Create Product Failed", context, Colors.red);
          }
        } else {
          Map<String, dynamic> formMap = {
            "name": nameProduct.text,
            "desc": descProduct.text,
            "price": priceProduct.text,
            "lat": lat.text,
            "long": long.text,
          };

          if (_image != null) {
            formMap["image"] = await MultipartFile.fromFile(
              _image!.path,
              filename: _image!.path.split('/').last,
            );
          }

          FormData formData = FormData.fromMap(formMap);

          var response =
              await _homeProvider.updateProduct(formData, widget.product!.id);
          if (response) {
            showSnackbar("Product saved successfully", context, Colors.green);
            await _homeProvider.getAllProducts(reset: true);
            context.pop();
          } else {
            showSnackbar("Product save failed", context, Colors.red);
          }
        }
      } catch (e) {
        print(e);
        print('Gagal...');
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameProduct.clear();
    descProduct.clear();
    priceProduct.clear();
    long.clear();
    lat.clear();
  }

  @override
  Widget build(BuildContext context) {
    Widget _formInput() {
      Widget _submitButton() {
        return Consumer<HomeProvider>(
          builder: (context, homeProvider, _) {
            if (homeProvider.state == ResultState.Loading) {
              return Container(
                margin: const EdgeInsets.only(top: 32, bottom: 4),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.red,
                  ),
                ),
              );
            } else {
              return ElevatedButton(
                onPressed: () {
                  submit(context);
                },
                child: Text('${widget.type} Product'),
              );
            }
          },
        );
      }

      return Form(
        key: formKey,
        child: Column(
          children: [
            const SizedBox(height: 10),
            TextFormField(
              controller: nameProduct,
              validator: MultiValidator([
                RequiredValidator(errorText: 'Name Product is required'),
              ]).call,
              decoration: const InputDecoration(
                labelText: 'Name Product',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: descProduct,
              validator: MultiValidator([
                RequiredValidator(errorText: 'Description Product is required'),
              ]).call,
              decoration: const InputDecoration(
                labelText: 'Description Product',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: priceProduct,
              validator: MultiValidator([
                RequiredValidator(errorText: 'Price Product is required'),
              ]).call,
              decoration: const InputDecoration(
                labelText: 'Price Product',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                if (_image != null)
                  Container(
                    height: 100,
                    width: 100,
                    child: Image.file(_image!),
                  )
                else if (_initialImageUrl != null)
                  Container(
                    height: 100,
                    width: 100,
                    child: Image.network(_initialImageUrl!),
                  )
                else
                  Text("No Image Selected"),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    getImage();
                  },
                  child: Text(
                    "Take Picture",
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            _submitButton()
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.type} Products"),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        children: [
          _formInput(),
        ],
      ),
    );
  }
}
