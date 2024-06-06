import 'package:flutter_example/core/interfaces/cache_manager_interface.dart';
import 'package:flutter_example/core/interfaces/cache_repository_async_interface.dart';
import 'package:flutter_example/core/models/cache/cache_model.dart';
import 'package:flutter_example/core/models/result_model.dart';

class CacheManager implements ICacheManager {
  final ICacheRepositoryAsync _cacheDatabaseManager;

  CacheManager(ICacheRepositoryAsync cacheDatabaseManager) : _cacheDatabaseManager = cacheDatabaseManager;

  @override
  Future<Result<T, Exception>> getItem<T>(String key) async {
    try {
      final cacheResult = await _cacheDatabaseManager.getItem(key);
      final isValid = await _validateCache(cacheResult);

      if (!isValid) {
        return Failure(Exception('Cache is not valid'));
      }

      return Success(cacheResult!.value);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<List<T>, Exception>> getItems<T>(String key) async {
    try {
      final cacheResult = await _cacheDatabaseManager.getItem(key);
      final isValid = await _validateCache(cacheResult);

      if (!isValid) {
        return Failure(Exception('Cache is not valid'));
      }

      return Success(cacheResult!.value.cast<T>());
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<bool, Exception>> putItem<T>(String key, T item, Duration duration) async {
    try {
      final cacheModel = CacheModel(
        expiration: DateTime.now().add(duration),
        value: item,
      );

      await _cacheDatabaseManager.putItem(key, cacheModel);
      return const Success(true);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<bool, Exception>> removeItem(String key) async {
    try {
      await _cacheDatabaseManager.removeItem(key);
      return const Success(true);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<bool, Exception>> clearAll() async {
    try {
      await _cacheDatabaseManager.clearAll();
      return const Success(true);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<bool> _validateCache(CacheModel? model) async {
    if (model == null) {
      await clearAll();
      return false;
    }

    if (model.expiration.isBefore(DateTime.now())) {
      await clearAll();
      return false;
    }

    return true;
  }
}
