import 'package:flutter_example/modules/auth/views/login_view.dart';
import 'package:flutter_example/modules/home/view/home_view.dart';
import 'package:flutter_example/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  final di = await DependencyInjection.registerServices();

  runApp(MyApp(
    di: di,
  ));
}

class MyApp extends StatelessWidget {
  final GetIt di;
  const MyApp({super.key, required this.di});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Caching',
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      routerConfig: GoRouter(
        initialLocation: '/login',
        routes: [
          GoRoute(
            path: '/login',
            name: 'login',
            builder: (context, state) => LoginView(
              authService: di.get(),
            ),
          ),
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) {
              return HomeView(homeService: di.get());
            },
          )
        ],
      ),
    );
  }
}
