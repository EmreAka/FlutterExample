import 'package:flutter_example/core/interfaces/repository_async_interface.dart';
import 'package:flutter_example/shared/constants/hive_constants.dart';
import 'package:flutter_example/core/models/cache/cache_model.dart';
import 'package:flutter_example/modules/home/models/post/post_model.dart';
import 'package:flutter_example/shared/models/user.model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveRepositoryBase<T> implements IRepositoryAsync<T> {
  late final String _key;

  late final Box<T> _box;

  HiveRepositoryBase(String key) {
    _key = key;
  }

  @override
  Future<void> addItems(List<T> items) async {
    await _box.addAll(items);
  }

  @override
  Future<T?> getItem(String key) async {
    return _box.get(key);
  }

  @override
  Future<void> putItem(String key, T item) async {
    await _box.put(key, item);
  }

  @override
  Future<void> removeItem(String key) async {
    await _box.delete(key);
  }

  @override
  Future<List<T>?> getValues() async {
    return _box.values.toList();
  }

  @override
  Future<void> clearAll() async {
    await _box.clear();
  }

  Future<void> init() async {
    registerAdapters();
    _box = await Hive.openBox<T>(_key);
  }

  void registerAdapters() {
    if (!Hive.isAdapterRegistered(HiveConstants.cacheTypeId)) {
      Hive.registerAdapter(CacheModelAdapter(), override: true);
    }
    if (!Hive.isAdapterRegistered(HiveConstants.postTypeId)) {
      Hive.registerAdapter(PostModelAdapter(), override: true);
    }
    if (!Hive.isAdapterRegistered(HiveConstants.expirableTypeId)) {
      Hive.registerAdapter(ExpirableAdapter(), override: true);
    }
    if (!Hive.isAdapterRegistered(HiveConstants.nonExpirableTypeId)) {
      Hive.registerAdapter(NonExpirableAdapter(), override: true);
    }
    if (!Hive.isAdapterRegistered(HiveConstants.userTypeId)) {
      Hive.registerAdapter(UserModelAdapter(), override: true);
    }
    if (!Hive.isAdapterRegistered(HiveConstants.companyTypeId)) {
      Hive.registerAdapter(CompanyModelAdapter(), override: true);
    }
    if (!Hive.isAdapterRegistered(HiveConstants.addressTypeId)) {
      Hive.registerAdapter(AddressModelAdapter(), override: true);
    }
    if (!Hive.isAdapterRegistered(HiveConstants.geoTypeId)) {
      Hive.registerAdapter(GeoModelAdapter(), override: true);
    }
  }
}
