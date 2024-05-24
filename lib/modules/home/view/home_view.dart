import 'package:flutter_example/modules/home/interfaces/home_service_interface.dart';
import 'package:flutter_example/modules/home/mixin/home_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_example/modules/home/state/home_state.dart';
import 'package:flutter_example/shared/providers/store_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:signals/signals_flutter.dart';

class HomeView extends StatefulWidget {
  final IHomeService homeService;

  const HomeView({
    super.key,
    required this.homeService,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with HomeMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Watch(
          (context) => Text(
            StoreProvider.getUserStore(context).user()?.name ?? 'Posts',
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.pushNamed('dogs');
            },
            icon: const Icon(Icons.square_foot_outlined),
          ),
          IconButton(
            onPressed: () {
              StoreProvider.getUserStore(context).signOut();
            },
            icon: const Icon(Icons.logout),
          ),
          IconButton(
            onPressed: () {
              context.pushNamed('file');
            },
            icon: const Icon(Icons.file_download),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Watch(
            (_) => Visibility(
              visible: posts.value is LoadingState,
              child: LinearProgressIndicator(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await createPost();
        },
        child: const Icon(Icons.add),
      ),
      body: Watch(
        (context) => RefreshIndicator(
          onRefresh: onRefresh,
          child: switch (posts.value) {
            SuccessState(value: final posts) => ListView.separated(
                padding: const EdgeInsets.all(24),
                itemBuilder: (context, index) => Card(
                  color: Theme.of(context).colorScheme.onInverseSurface,
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
      ),
    );
  }
}
