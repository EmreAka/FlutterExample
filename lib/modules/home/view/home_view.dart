import 'package:flutter_example/modules/home/interfaces/home_service_interface.dart';
import 'package:flutter_example/modules/home/mixin/home_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_example/modules/home/state/home_state.dart';
import 'package:flutter_example/shared/stores/user_store.dart';
import 'package:signals/signals_flutter.dart';

class HomeView extends StatefulWidget {
  final IHomeService homeService;
  final UserStore userStore;

  const HomeView({
    super.key,
    required this.homeService,
    required this.userStore,
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
            widget.userStore.user()?.name ?? 'Posts',
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              widget.userStore.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await createPost();
          //await downloadFile();
        },
        child: const Icon(Icons.add),
      ),
      body: Watch(
        (context) => RefreshIndicator(
          onRefresh: getPost,
          child: switch (posts.value) {
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
