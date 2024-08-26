import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

bool isConnectionSecure = true;

class ApiServices {
  final box = GetStorage();

  Dio launch() {
    Dio dio = Dio();

    // Add logging interceptor
    dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: true,
        error: true,
        compact: true,
        maxWidth: 1000));

    // Add headers
    dio.options.headers["accept"] = 'application/json';
    if (box.read('token') != null) {
      dio.options.headers["Authorization"] = 'Bearer ${box.read('token')}';
    }

    dio.options.followRedirects = false;
    dio.options.validateStatus = (s) {
      return s! < 500;
    };

    // Add an interceptor to handle errors
    dio.interceptors.add(InterceptorsWrapper(
      onError: (DioException error, ErrorInterceptorHandler handler) {
        // Check if the error is due to authorization
        if (error.response?.statusCode == 401 ||
            error.response?.statusCode == 403) {
          print("ini session abis");
          // Clear token (optional)
          // box.remove(KeyValue.keyToken);

          // Redirect to login page
          // Get.offAllNamed('/login');  // Redirects to 'login' route
        }

        // Continue with the error handling
        return handler.next(error);
      },
    ));

    return dio;
  }
}
