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

  final loading = signal<HomeState>(const IdleState());
  var posts = <PostModel>[];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await getPost();
    });
  }

  Future getPost() async {
    loading.value = const LoadingState();
    showLoadingDialog();

    final result = await widget.homeService.getPosts();

    switch (result) {
      case Success(value: final value):
        setState(() {
          posts = value;
        });
        loading.value = SuccessState(value.first);
        closeLoadingDialog();
        break;
      case Failure(exception: final exception):
        log('Error: $exception');
        loading.value = const ErrorState();
        closeLoadingDialog();
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
