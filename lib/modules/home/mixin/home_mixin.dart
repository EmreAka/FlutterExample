import 'dart:developer';

import 'package:flutter_example/core/models/result_model.dart';
import 'package:flutter_example/modules/home/interfaces/home_service_interface.dart';
import 'package:flutter_example/modules/home/view/home_view.dart';
import 'package:flutter_example/service_locator.dart';
import 'package:flutter/material.dart';

mixin HomeMixin on State<HomeView> {
  Future getPost() async {
    final postHttpClient = serviceLocator.get<IHomeService>();

    final posts = await postHttpClient.getPosts();

    switch(posts) {
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
}
