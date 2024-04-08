import 'package:flutter_example/modules/home/mixin/home_mixin.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with HomeMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Caching'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ElevatedButton(
            onPressed: () async {
              await getPost();
            },
            style: ButtonStyle(
              foregroundColor: MaterialStateColor.resolveWith(
                  (states) => Colors.black87),
              backgroundColor: MaterialStateColor.resolveWith(
                  (states) => Colors.black87),
              textStyle: MaterialStateProperty.resolveWith(
                (states) => const TextStyle(color: Colors.white),
              ),
            ),
            child:
                const Text('Get a post from cache', style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
