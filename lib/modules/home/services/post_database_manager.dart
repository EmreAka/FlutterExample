import 'package:flutter_example/core/services/persistence/hive_repository_base.dart';
import 'package:flutter_example/hive_constants.dart';
import 'package:flutter_example/modules/home/interfaces/post_repository_interface.dart';
import 'package:flutter_example/modules/home/models/post/post_model.dart';

class PostDatabaseManager extends HiveRepositoryBase<PostModel>
    implements IPostRepositoryAsync {
  PostDatabaseManager() : super(HiveConstants.postBox);
}
