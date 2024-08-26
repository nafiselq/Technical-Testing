import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hcaptcha/hcaptcha.dart';
import 'package:mobileapps/core/routes/my_router.dart';
import 'package:mobileapps/features/Auth/presentation/providers/login_provider.dart';
import 'package:mobileapps/features/Home/presentation/providers/home_provider.dart';
import 'package:mobileapps/injection.dart';
import 'package:provider/provider.dart';

void main() async {
  await init();
  await GetStorage.init();
  HCaptcha.init(siteKey: '148a02e0-d1c6-459a-bb40-8e64c954a1a6');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => myInjection<LoginProvider>(),
        ),
        ChangeNotifierProvider(
          create: (context) => myInjection<HomeProvider>(),
        )
      ],
      child: MaterialApp.router(
        title: 'Techincal Test',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: MyRouter().router,
      ),
    );
  }
}
