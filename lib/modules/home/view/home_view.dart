import 'package:flutter_example/modules/home/interfaces/home_service_interface.dart';
import 'package:flutter_example/modules/home/mixin/home_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_example/modules/home/state/home_state.dart';
import 'package:signals/signals_flutter.dart';

class HomeView extends StatefulWidget {
  final IHomeService homeService;

  const HomeView({super.key, required this.homeService});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with HomeMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
      ),
      body: Watch(
        (context) => switch (posts.value) {
          SuccessState(value: final posts) => ListView.separated(
              padding: const EdgeInsets.all(24),
              itemBuilder: (context, index) => Card(
                child: ListTile(
                  title: Text(posts[index].title),
                  subtitle: Text(posts[index].body),
                ),
              ),
              separatorBuilder: (context, index) => const SizedBox(
                height: 10,
              ),
              itemCount: posts.length,
            ),
          ErrorState() => const Center(
              child: Text('Posts could not be loaded. Please try again later.'),
            ),
          _ => const SizedBox()
        },
      ),
    );
  }

  Padding oldBody() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              await getPost();
            },
            style: ButtonStyle(
              foregroundColor: MaterialStateColor.resolveWith((states) => Colors.black87),
              backgroundColor: MaterialStateColor.resolveWith((states) => Colors.black87),
              textStyle: MaterialStateProperty.resolveWith(
                (states) => const TextStyle(color: Colors.white),
              ),
            ),
            child: const Text('Get a post', style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            onPressed: () async {
              await createPost();
            },
            style: ButtonStyle(
              foregroundColor: MaterialStateColor.resolveWith((states) => Colors.black87),
              backgroundColor: MaterialStateColor.resolveWith((states) => Colors.black87),
              textStyle: MaterialStateProperty.resolveWith(
                (states) => const TextStyle(color: Colors.white),
              ),
            ),
            child: const Text('Create a post', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(height: 24),
          Center(
            child: Watch((context) {
              final state = posts.value;
              return switch (state) {
                LoadingState() => const CircularProgressIndicator(),
                SuccessState(value: final value) => Table(
                    columnWidths: const {
                      0: FlexColumnWidth(1),
                      1: FlexColumnWidth(2),
                    },
                    children: [
                      TableRow(children: [
                        const Text('ID:'),
                        Text('${value.first.id}'),
                      ]),
                      TableRow(children: [
                        const Text('Title:'),
                        Text(value.first.title),
                      ]),
                      TableRow(children: [
                        const Text('Body:'),
                        Text(value.first.body),
                      ]),
                    ],
                  ),
                ErrorState() => const Text('Error'),
                IdleState() => const Text('Idle'),
              };
            }),
          )
        ],
      ),
    );
  }

  @override
  void closeLoadingDialog() {
    if (mounted && Navigator.of(context).canPop() && isDialogOpen) Navigator.of(context).pop();
  }

  @override
  void showLoadingDialog() {
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
