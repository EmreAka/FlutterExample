import 'package:flutter_example/core/interfaces/cache_manager_interface.dart';
import 'package:flutter_example/core/interfaces/cache_repository_async_interface.dart';
import 'package:flutter_example/core/services/cache/cache_manager.dart';
import 'package:flutter_example/core/services/cache/cache_repository_async.dart';
import 'package:flutter_example/core/services/network/network_manager.dart';
import 'package:flutter_example/modules/home/interfaces/home_service_interface.dart';
import 'package:flutter_example/modules/home/interfaces/post_repository_async_interface.dart';
import 'package:flutter_example/modules/home/services/home_service.dart';
import 'package:flutter_example/modules/home/services/post_repository_async.dart';
import 'package:flutter_example/modules/home/services/post_http_client.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

void registerServices() {
  serviceLocator.registerSingletonAsync<ICacheRepositoryAsync>(() async {
    final cacheDatabaseManager = CacheRepositoryAsync();
    await cacheDatabaseManager.init();
    return cacheDatabaseManager;
  });

  serviceLocator.registerSingletonWithDependencies<ICacheManager>(() {
    return CacheManager(serviceLocator.get<ICacheRepositoryAsync>());
  }, dependsOn: [ICacheRepositoryAsync]);

  serviceLocator.registerSingletonAsync<IPostRepositoryAsync>(() async {
    final postDatabaseManager = PostRepositoryAsync();
    await postDatabaseManager.init();
    return postDatabaseManager;
  });

  serviceLocator.registerFactory<IPostHttpClient>(() =>
      PostHttpClient(NetworkManager('https://jsonplaceholder.typicode.com/')));

  serviceLocator.registerFactory<IHomeService>(
    () => HomeService(
      serviceLocator.get<ICacheManager>(),
      serviceLocator.get<IPostHttpClient>(),
    ),
  );
}
