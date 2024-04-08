import 'dart:developer';

import 'package:flutter_example/core/models/result_model.dart';
import 'package:flutter_example/modules/home/interfaces/home_service_interface.dart';
import 'package:flutter_example/modules/home/models/post/post_model.dart';
import 'package:flutter_example/modules/home/state/home_state.dart';
import 'package:flutter_example/modules/home/view/home_view.dart';
import 'package:flutter_example/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

mixin HomeMixin on State<HomeView> {
  final loading = signal<HomeState>(const IdleState());

  Future getPost() async {
    loading.value = const LoadingState();

    final posts = await widget.homeService.getPosts();

    switch (posts) {
      case Success(value: final value):
        for (final post in value) {
          log(post.id.toString());
          log(post.title);
          log(post.body);
        }

        loading.value = SuccessState(value.first);
        break;
      case Failure(exception: final exception):
        log('Error: $exception');
        loading.value = const ErrorState();
        break;
    }
  }

  Future<void> createPost() async {
    final homeService = serviceLocator.get<IHomeService>();

    final post = PostModel(
      id: 5,
      title: 'Title of the post',
      body: 'Body of the post object',
    );

    final result = await homeService.createPost(post);
    
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
  }
}
