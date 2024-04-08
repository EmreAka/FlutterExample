import 'package:flutter_example/core/interfaces/cache_manager_interface.dart';
import 'package:flutter_example/core/interfaces/repository_async_interface.dart';
import 'package:flutter_example/core/models/cache/cache_model.dart';

class CacheManager implements ICacheManager {
  late final IRepositoryAsync<CacheModel> _cacheDatabaseManager;

  CacheManager(this._cacheDatabaseManager);

  @override
  Future<T?> getItem<T>(String key) async {
    final cacheResult = await _cacheDatabaseManager.getItem(key);
    final isValid = await _validateCache(cacheResult);

    if (!isValid) {
      return null;
    }

    return cacheResult?.value;
  }

  @override
  Future<List<T>?> getItems<T>(String key) async {
    final cacheResult = await _cacheDatabaseManager.getItem(key);
    final isValid = await _validateCache(cacheResult);

    if (!isValid) {
      return null;
    }

    return cacheResult?.value?.cast<T>();
  }

  @override
  Future<void> putItem<T>(String key, T item, Duration duration) async {
    final cacheModel = CacheModel(
      expiration: DateTime.now().add(duration),
      value: item,
    );

    await _cacheDatabaseManager.putItem(key, cacheModel);
  }

  @override
  Future<void> removeItem(String key) async {
    await _cacheDatabaseManager.removeItem(key);
  }

  @override
  Future<void> clearAll() async {
    await _cacheDatabaseManager.clearAll();
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
