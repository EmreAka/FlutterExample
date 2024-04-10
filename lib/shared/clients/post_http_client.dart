import 'package:flutter_example/core/helpers/result_converter.dart';
import 'package:flutter_example/core/interfaces/network_manager_interface.dart';
import 'package:flutter_example/core/models/result_model.dart';
import 'package:flutter_example/core/helpers/json_parser.dart';
import 'package:flutter_example/modules/home/models/post/post_model.dart';

abstract class IPostHttpClient {
  Future<Result<PostModel, Exception>> getPostById(int id);
  Future<Result<List<PostModel>, Exception>> getPosts();
  Future<Result<PostModel, Exception>> createPost(PostModel post);
}

class PostHttpClient implements IPostHttpClient {
  final INetworkManager _networkManager;

  PostHttpClient(this._networkManager);

  @override
  Future<Result<PostModel, Exception>> getPostById(int id) async {
    final result = await _networkManager.get('posts/$id');

    final Result<PostModel, Exception> post = ResultConverter.toResult(
        result, (value) => JsonParser.parseMap(PostModel.fromJson, value));

    return post;
  }

  @override
  Future<Result<List<PostModel>, Exception>> getPosts() async {
    final result = await _networkManager.get('posts');

    final Result<List<PostModel>, Exception> posts = ResultConverter.toResult(
        result, (value) => JsonParser.parseList(PostModel.fromJson, value));

    return posts;
  }

  @override
  Future<Result<PostModel, Exception>> createPost(PostModel post) async {
    final result = await _networkManager.post('posts', data: post);

    final Result<PostModel, Exception> createdPost = ResultConverter.toResult(
        result, (value) => JsonParser.parseMap(PostModel.fromJson, value));

    return createdPost;
  }
}
