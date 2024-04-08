import 'package:flutter_example/core/interfaces/cache_manager_interface.dart';
import 'package:flutter_example/core/models/result_model.dart';
import 'package:flutter_example/modules/home/interfaces/home_service_interface.dart';
import 'package:flutter_example/modules/home/models/post/post_model.dart';
import 'package:flutter_example/shared/clients/post_http_client.dart';

class HomeService implements IHomeService {
  final ICacheManager _cacheManager;
  final IPostHttpClient _postHttpClient;

  HomeService(this._cacheManager, this._postHttpClient);

  @override
  Future<Result<PostModel, Exception>> getPostById(int id) async {
    final post = await _postHttpClient.getPostById(id);
    return post;
  }

  @override
  Future<Result<List<PostModel>, Exception>> getPosts() async {
    final cachedResult = await _cacheManager.getItems<PostModel>('posts');

    if (cachedResult != null) {
      return Success(cachedResult);
    }

    final posts = await _postHttpClient.getPosts();

    if (cachedResult == null && posts is Success) {
      await _cacheManager.putItem('posts',(posts as Success).value, const Duration(minutes: 1));
    }

    return posts;
  }
}