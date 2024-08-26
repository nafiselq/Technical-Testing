import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:hcaptcha/hcaptcha.dart';
import '../providers/login_provider.dart';
import '../../../../utils/result_state.dart';
import '../../../../utils/snackbar_custom.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double _height = 1;
  bool showCaptcha = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();
  bool isCaptcha = false;
  final box = GetStorage();
  WebViewPlusController? _controller;

  Widget _submitButton() {
    return Consumer<LoginProvider>(
      builder: (context, loginProvider, _) {
        if (loginProvider.state == ResultState.Loading) {
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
            onPressed: isCaptcha
                ? () {
                    login(context);
                  }
                : null,
            child: const Text('Login'),
          );
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    initScreen();
    // requestStoragePermission();
    _determinePosition();
  }

  void initScreen() async {
    var hasToken = box.read("token");
    if (hasToken != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.pushNamed('home');
      });
    }
  }

  void requestStoragePermission() async {
    // Check if the platform is not web, as web has no permissions
    if (!kIsWeb) {
      // Request storage permission
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }

      // Request camera permission
      var cameraStatus = await Permission.camera.status;
      if (!cameraStatus.isGranted) {
        await Permission.camera.request();
      }
    }
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

  void login(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      try {
        //asd
        LoginProvider loginProvider =
            Provider.of<LoginProvider>(context, listen: false);

        String email = emailC.text;
        String password = passC.text;

        await loginProvider.loginProvider(email, password);

        if (loginProvider.state == ResultState.Error) {
          showSnackbar(loginProvider.message.toString(), context, Colors.red);
        } else if (loginProvider.state == ResultState.HasData) {
          context.goNamed('home');
        }
      } catch (e) {
        print('Gagal...');
      }
    }
  }

  @override
  void dispose() {
    emailC.clear();
    passC.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              const SizedBox(height: 150),
              TextFormField(
                controller: emailC,
                validator: MultiValidator([
                  RequiredValidator(errorText: 'Email is required'),
                  EmailValidator(errorText: 'Enter a valid email address'),
                ]).call,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: passC,
                validator: MultiValidator([
                  RequiredValidator(errorText: 'Password is required'),
                ]).call,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                height: _height,
                child: WebViewPlus(
                  serverPort: 5353,
                  javascriptChannels: Set.from([
                    JavascriptChannel(
                        name: 'Captcha',
                        onMessageReceived: (JavascriptMessage message) {
                          setState(() {
                            isCaptcha = true;
                            _height = 118;
                          });
                        })
                  ]),
                  initialUrl: 'assets/webpages/index.html',
                  onWebViewCreated: (controller) {
                    _controller = controller;
                  },
                  onPageFinished: (url) {
                    _controller?.getHeight().then((double height) {
                      print("ini height: $height");
                      showCaptcha = true;
                      setState(() {
                        _height = 500;
                      });
                    });
                  },
                  javascriptMode: JavascriptMode.unrestricted,
                ),
              ),
              isCaptcha ? _submitButton() : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
