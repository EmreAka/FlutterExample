import 'dart:developer';

import 'package:flutter_example/core/models/result_model.dart';
import 'package:flutter_example/modules/home/models/post/post_model.dart';
import 'package:flutter_example/modules/home/state/home_state.dart';
import 'package:flutter_example/modules/home/view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

mixin HomeMixin on State<HomeView> {
  final posts = signal<HomeState>(const IdleState());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await getPost();
    });

    super.initState();
  }

  @override
  void dispose() {
    posts.dispose();
    super.dispose();
  }

  Future<void> onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final result = await widget.homeService.getPosts();

    posts.value = switch (result) {
      Success(value: final value) => SuccessState(value),
      Failure(exception: final _) => const ErrorState()
    };
  }

  Future<void> getPost() async {
    posts.value = const LoadingState();

    await Future.delayed(const Duration(milliseconds: 500));

    final result = await widget.homeService.getPosts();

    posts.value = switch (result) {
      Success(value: final value) => SuccessState(value),
      Failure(exception: final _) => const ErrorState()
    };
  }

  Future<void> createPost() async {
    final post = PostModel(
      id: 5,
      title: 'Title of the post',
      body: 'Body of the post object',
    );

    final result = await widget.homeService.createPost(post);

    switch (result) {
      case Success(value: final value):
        log(value.id.toString());
        log(value.title);
        log(value.body);
        if (posts.value is SuccessState) {
          posts.value = SuccessState([...(posts.value as SuccessState).value, value]);
          break;
        }
        break;
      case Failure(exception: final exception):
        log('Error: $exception');
        break;
    }
  }
}
