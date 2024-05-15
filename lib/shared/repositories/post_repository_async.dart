import 'package:flutter_example/core/services/persistence/hive_repository_base.dart';
import 'package:flutter_example/shared/constants/hive_constants.dart';
import 'package:flutter_example/shared/interfaces/post_repository_async_interface.dart';
import 'package:flutter_example/modules/home/models/post/post_model.dart';

class PostRepositoryAsync extends HiveRepositoryBase<PostModel>
    implements IPostRepositoryAsync {
  PostRepositoryAsync() : super(HiveConstants.postBox);
}
