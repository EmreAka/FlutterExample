import 'package:flutter_example/modules/home/view/home_view.dart';
import 'package:flutter_example/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  registerServices();
  await serviceLocator.allReady();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Caching',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeView()
    );
  }
}
