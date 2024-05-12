import 'package:flutter_example/core/models/result_model.dart';
import 'package:flutter_example/modules/home/models/post/post_model.dart';

abstract class IHomeService {
  Future<Result<PostModel, Exception>> getPostById(int id);
  Future<Result<List<PostModel>, Exception>> getPosts();
  Future<Result<PostModel, Exception>> createPost(PostModel post);
  Future<Result<bool, Exception>> downloadFile(String fileUrl, String fileName);
}