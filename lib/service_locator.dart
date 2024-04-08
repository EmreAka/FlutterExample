import 'package:flutter_example/core/interfaces/cache_manager_interface.dart';
import 'package:flutter_example/core/interfaces/cache_repository_async_interface.dart';
import 'package:flutter_example/core/services/cache/cache_manager.dart';
import 'package:flutter_example/core/services/cache/cache_repository_async.dart';
import 'package:flutter_example/core/services/network/network_manager.dart';
import 'package:flutter_example/modules/home/interfaces/home_service_interface.dart';
import 'package:flutter_example/modules/home/interfaces/post_repository_async_interface.dart';
import 'package:flutter_example/modules/home/services/home_service.dart';
import 'package:flutter_example/shared/repositories/post_repository_async.dart';
import 'package:flutter_example/shared/clients/post_http_client.dart';
import 'package:get_it/get_it.dart';

class DependencyInjection {
  static final _serviceLocator = GetIt.instance;

  static Future<GetIt> registerServices() async {
    _serviceLocator.registerSingletonAsync<ICacheRepositoryAsync>(() async {
      final cacheDatabaseManager = CacheRepositoryAsync();
      await cacheDatabaseManager.init();
      return cacheDatabaseManager;
    });

    _serviceLocator.registerSingletonWithDependencies<ICacheManager>(() {
      return CacheManager(_serviceLocator.get<ICacheRepositoryAsync>());
    }, dependsOn: [ICacheRepositoryAsync]);

    _serviceLocator.registerSingletonAsync<IPostRepositoryAsync>(() async {
      final postDatabaseManager = PostRepositoryAsync();
      await postDatabaseManager.init();
      return postDatabaseManager;
    });

    _serviceLocator.registerFactory<IPostHttpClient>(
        () => PostHttpClient(NetworkManager('https://jsonplaceholder.typicode.com/')));

    _serviceLocator.registerFactory<IHomeService>(
      () => HomeService(
        _serviceLocator.get<ICacheManager>(),
        _serviceLocator.get<IPostHttpClient>(),
      ),
    );

    await _serviceLocator.allReady();
    return _serviceLocator;
  }
}
