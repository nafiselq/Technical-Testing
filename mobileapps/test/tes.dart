import 'package:mobileapps/features/Auth/data/datasources/remote_datasource.dart';

void main() {
  final AuthRemoteDataSourceImpl authRemoteDataSourceImpl =
      AuthRemoteDataSourceImpl();

  var response =
      authRemoteDataSourceImpl.login("admin@adminds.comas", "admiaasdasdn");
  print(response);
}
