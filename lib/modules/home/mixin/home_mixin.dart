import 'dart:developer';

import 'package:flutter_example/core/models/result_model.dart';
import 'package:flutter_example/modules/home/interfaces/home_service_interface.dart';
import 'package:flutter_example/modules/home/models/post/post_model.dart';
import 'package:flutter_example/modules/home/view/home_view.dart';
import 'package:flutter_example/service_locator.dart';
import 'package:flutter/material.dart';

mixin HomeMixin on State<HomeView> {
  Future getPost() async {
    final homeService = serviceLocator.get<IHomeService>();

    final posts = await homeService.getPosts();

    switch (posts) {
      case Success(value: final value):
        for (final post in value) {
          log(post.id.toString());
          log(post.title);
          log(post.body);
        }
        break;
      case Failure(exception: final exception):
        log('Error: $exception');
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
