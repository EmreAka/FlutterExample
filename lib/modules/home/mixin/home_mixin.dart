import 'dart:developer';

import 'package:flutter_example/core/models/result_model.dart';
import 'package:flutter_example/modules/home/models/post/post_model.dart';
import 'package:flutter_example/modules/home/state/home_state.dart';
import 'package:flutter_example/modules/home/view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

mixin HomeMixin on State<HomeView> {
  void showLoadingDialog();
  void closeLoadingDialog();

  final posts = signal<HomeState>(const IdleState());
  late final EffectCleanup disposePostsEffect;
  var isDialogOpen = false;

  @override
  void initState() {
    disposePostsEffect = registerPostsEffect();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await getPost();
    });

    super.initState();
  }

  EffectCleanup registerPostsEffect() {
    return effect(
    () {
      switch (posts.value) {
        case LoadingState():
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
            showLoadingDialog();
            isDialogOpen = true;
          });
          break;
        default:
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
            closeLoadingDialog();
            isDialogOpen = false;
          });
          break;
      }
    },
  );
  }

  @override
  void dispose() {
    disposePostsEffect();
    posts.dispose();
    super.dispose();
  }

  Future getPost() async {
    posts.value = const LoadingState();

    final result = await widget.homeService.getPosts();

    switch (result) {
      case Success(value: final value):
        posts.value = SuccessState(value);
        break;
      case Failure(exception: final exception):
        log('Error: $exception');
        posts.value = const ErrorState();
        break;
    }
  }

  Future<void> createPost() async {
    showLoadingDialog();

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
        break;
      case Failure(exception: final exception):
        log('Error: $exception');
        break;
    }

    closeLoadingDialog();
  }
}
