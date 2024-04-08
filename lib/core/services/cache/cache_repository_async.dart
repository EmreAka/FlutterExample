import 'package:flutter_example/core/interfaces/cache_repository_async_interface.dart';
import 'package:flutter_example/core/services/persistence/hive_repository_base.dart';
import 'package:flutter_example/core/models/cache/cache_model.dart';
import 'package:flutter_example/hive_constants.dart';

class CacheRepositoryAsync extends HiveRepositoryBase<CacheModel>
    implements ICacheRepositoryAsync {
  CacheRepositoryAsync(): super(HiveConstants.cacheBox);
}
