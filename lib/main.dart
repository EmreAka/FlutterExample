import 'package:flutter_example/modules/home/view/home_view.dart';
import 'package:flutter_example/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Caching',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeView(
        homeService: di.get(),
      ),
    );
  }
}
