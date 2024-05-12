import 'dart:developer';

import 'package:flutter_example/core/interfaces/cache_manager_interface.dart';
import 'package:flutter_example/core/interfaces/download_file_manager_interface.dart';
import 'package:flutter_example/core/models/result_model.dart';
import 'package:flutter_example/modules/home/interfaces/home_service_interface.dart';
import 'package:flutter_example/modules/home/models/post/post_model.dart';
import 'package:flutter_example/shared/clients/post_http_client.dart';

class HomeService implements IHomeService {
  final ICacheManager _cacheManager;
  final IPostHttpClient _postHttpClient;
  final IDownloadFileManager _downloadFileManager;

  HomeService(
    this._cacheManager,
    this._postHttpClient,
    this._downloadFileManager,
  );

  @override
  Future<Result<PostModel, Exception>> getPostById(int id) async {
    final post = await _postHttpClient.getPostById(id);
    return post;
  }

  @override
  Future<Result<List<PostModel>, Exception>> getPosts() async {
    final cachedResult = await _cacheManager.getItems<PostModel>('posts');

    if (cachedResult is Success) {
      log('Cache read', name: 'HomeService.getPosts');
      return cachedResult;
    }

    final posts = await _postHttpClient.getPosts();

    if (posts is Success) {
      log('Cache write', name: 'HomeService.getPosts');
      await _cacheManager.putItem('posts', (posts as Success).value, const Duration(minutes: 1));
    }

    return posts;
  }

  @override
  Future<Result<PostModel, Exception>> createPost(PostModel post) async {
    final createdPost = await _postHttpClient.createPost(post);
    return createdPost;
  }

  @override
  Future<Result<bool, Exception>> downloadFile(String fileUrl, String fileName) async {
    final downloadResult = await _downloadFileManager.downloadFile(fileUrl, fileName);
    return downloadResult;
  }
}
