import 'package:flutter_example/core/interfaces/cache_repository_async_interface.dart';
import 'package:flutter_example/core/services/persistence/hive_repository_base.dart';
import 'package:flutter_example/shared/constants/hive_constants.dart';

class CacheRepositoryAsync extends HiveRepositoryBase implements ICacheRepositoryAsync {
  CacheRepositoryAsync() : super(HiveConstants.cacheBox);
}
