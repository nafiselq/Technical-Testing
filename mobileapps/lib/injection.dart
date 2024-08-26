import 'package:get_it/get_it.dart';
import 'package:mobileapps/features/Auth/data/datasources/remote_datasource.dart';
import 'package:mobileapps/features/Auth/data/repositories/login_repository_impl.dart';
import 'package:mobileapps/features/Auth/domain/repositories/login_repository.dart';
import 'package:mobileapps/features/Auth/domain/usecases/login_usecase.dart';
import 'package:mobileapps/features/Auth/presentation/providers/login_provider.dart';
import 'package:mobileapps/features/Home/data/datasources/remote_datasource.dart';
import 'package:mobileapps/features/Home/data/repositories/home_repository_impl.dart';
import 'package:mobileapps/features/Home/domain/repositories/home_repository.dart';
import 'package:mobileapps/features/Home/domain/usecases/delete_product_usecase.dart';
import 'package:mobileapps/features/Home/domain/usecases/get_all_data_usecase.dart';
import 'package:mobileapps/features/Home/domain/usecases/home_usecase.dart';
import 'package:mobileapps/features/Home/domain/usecases/update_product_usecase.dart';
import 'package:mobileapps/features/Home/presentation/providers/home_provider.dart';

var myInjection = GetIt.instance;

Future<void> init() async {
  // FEATURE - AUTH
  // PROVIDER
  myInjection.registerFactory(() => LoginProvider(loginCase: myInjection()));

  // USECASE
  myInjection.registerLazySingleton(() => Login(myInjection()));

  // REPOSITORY
  myInjection.registerLazySingleton<LoginRepository>(
      () => LoginRepositoryImpl(authRemoteDataSource: myInjection()));

  // DATA SOURCE
  myInjection.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl());

  // FEATURE - Home
  // PROVIDER
  myInjection.registerFactory(
    () => HomeProvider(
      homeCase: myInjection(),
      getAllProduct: myInjection(),
      updateProductUsecase: myInjection(),
      deleteProductUsecase: myInjection(),
    ),
  );

  // USECASE
  myInjection.registerLazySingleton(() => Home(myInjection()));
  myInjection.registerLazySingleton(() => GetAllProduct(myInjection()));
  myInjection.registerLazySingleton(() => UpdateProductUsecase(myInjection()));
  myInjection.registerLazySingleton(() => DeleteProductUsecase(myInjection()));

  // REPOSITORY
  myInjection.registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(homeDataResource: myInjection()));

  // DATA SOURCE
  myInjection.registerLazySingleton<HomeDataResource>(
      () => HomeRemoteDataSourceImpl());
}
