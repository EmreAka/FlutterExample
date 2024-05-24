import 'package:flutter_example/core/constants/network_constants.dart';
import 'package:flutter_example/core/interfaces/cache_manager_interface.dart';
import 'package:flutter_example/core/interfaces/cache_repository_async_interface.dart';
import 'package:flutter_example/core/interfaces/download_file_manager_interface.dart';
import 'package:flutter_example/core/interfaces/network_manager_interface.dart';
import 'package:flutter_example/core/interfaces/open_file_manager_interface.dart';
import 'package:flutter_example/core/services/cache/cache_manager.dart';
import 'package:flutter_example/core/services/cache/cache_repository_async.dart';
import 'package:flutter_example/core/services/file/download_file_manager.dart';
import 'package:flutter_example/core/services/file/open_file_manager.dart';
//import 'package:flutter_example/core/services/network/dio_network_manager.dart';
import 'package:flutter_example/core/services/network/http_network_manager.dart';
import 'package:flutter_example/modules/auth/interfaces/auth_service_interface.dart';
import 'package:flutter_example/modules/dog/interfaces/dog_service_interface.dart';
import 'package:flutter_example/modules/dog/service/dog_service.dart';
import 'package:flutter_example/shared/services/auth_service.dart';
import 'package:flutter_example/modules/file/interfaces/file_service_interface.dart';
import 'package:flutter_example/modules/file/service/file_service.dart';
import 'package:flutter_example/modules/home/interfaces/home_service_interface.dart';
import 'package:flutter_example/shared/interfaces/post_repository_async_interface.dart';
import 'package:flutter_example/modules/home/services/home_service.dart';
import 'package:flutter_example/shared/clients/users_http_client.dart';
import 'package:flutter_example/shared/repositories/post_repository_async.dart';
import 'package:flutter_example/modules/home/clients/post_http_client.dart';
import 'package:flutter_example/shared/stores/file_store.dart';
import 'package:flutter_example/shared/stores/user_store.dart';
import 'package:get_it/get_it.dart';

class DependencyInjection {
  static final _serviceLocator = GetIt.instance;

  static Future<GetIt> registerServices() async {
    _serviceLocator.registerSingleton<INetworkManager>(
      HttpNetworkManager(baseUrl: NetworkConstants.jsonPlaceholderBaseUrl),
    );

    /* _serviceLocator.registerSingleton<INetworkManager>(
      DioNetworkManager(baseUrl: NetworkConstants.jsonPlaceholderBaseUrl),
    ); */

    _serviceLocator.registerFactory<IDownloadFileManager>(
      () => DownloadFileManager(
        fileStore: _serviceLocator.get<FileStore>(),
      ),
    );

    /* _serviceLocator.registerFactory<IDownloadFileManager>(
      () => FlutterDownloaderDownloadFileManager(),
    ); */

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

    /* _serviceLocator.registerFactory<IPostHttpClient>(
      () => PostHttpClient(
        DioNetworkManager('https://jsonplaceholder.typicode.com/'),
      ),
    ); */

    _serviceLocator.registerFactory<IPostHttpClient>(
      () => PostHttpClient(
        _serviceLocator.get(),
      ),
    );

    _serviceLocator.registerFactory<IUserHttpClient>(
      () => UserHttpClient(
        _serviceLocator.get(),
      ),
    );

    _serviceLocator.registerFactory<IAuthService>(
      () => AuthService(
        userHttpClient: _serviceLocator.get<IUserHttpClient>(),
      ),
    );

    _serviceLocator.registerFactory<IHomeService>(
      () => HomeService(
        _serviceLocator.get<ICacheManager>(),
        _serviceLocator.get<IPostHttpClient>(),
      ),
    );

    _serviceLocator.registerFactory<IFileService>(
      () => FileService(
        downloadFileManager: _serviceLocator.get<IDownloadFileManager>(),
        openFileManager: _serviceLocator.get<IOpenFileManager>(),
      ),
    );

    _serviceLocator.registerSingleton(UserStore(
      authService: _serviceLocator.get<IAuthService>(),
    ));
    
    _serviceLocator.registerSingleton(FileStore());

    _serviceLocator.registerFactory<IOpenFileManager>(() => OpenFileXManager());

    _serviceLocator.registerFactory<IDogService>(() => DogService());

    await _serviceLocator.allReady();
    return _serviceLocator;
  }
}
