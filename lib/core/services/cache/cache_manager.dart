import 'dart:convert';

import 'package:flutter_example/core/helpers/json_parser.dart';
import 'package:flutter_example/core/interfaces/cache_manager_interface.dart';
import 'package:flutter_example/core/interfaces/cache_repository_async_interface.dart';
import 'package:flutter_example/core/models/cache/cache_model.dart';
import 'package:flutter_example/core/models/model_interface.dart';
import 'package:flutter_example/core/models/result_model.dart';

class CacheManager implements ICacheManager {
  final ICacheRepositoryAsync _cacheDatabaseManager;

  CacheManager(ICacheRepositoryAsync cacheDatabaseManager) : _cacheDatabaseManager = cacheDatabaseManager;

  @override
  Future<Result<T, Exception>> getItem<T>(String key, T Function(Map<String, Object?>) fromJson) async {
    try {
      final cacheResult = await _cacheDatabaseManager.getItem(key);
      final cacheResultJson = cacheResult != null ? jsonDecode(cacheResult) : null;
      final cacheModel = CacheModel.fromJson(cacheResultJson);
      final isValid = await _validateCache(key, cacheModel);

      if (!isValid) {
        return Failure(Exception('Cache is not valid'));
      }

      final cachedJsonValue = cacheModel.value;
      final jsonValue = jsonDecode(cachedJsonValue);

      final result = JsonParser.parseMap(fromJson, jsonValue);

      return result;
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<List<T>, Exception>> getItems<T>(
      String key, T Function(Map<String, Object?>) fromJson) async {
    try {
      final cacheResult = await _cacheDatabaseManager.getItem(key);
      final cacheResultJson = cacheResult != null ? jsonDecode(cacheResult) : null;
      final cacheModel = CacheModel.fromJson(cacheResultJson);
      final isValid = await _validateCache(key, cacheModel);

      if (!isValid) {
        return Failure(Exception('Cache is not valid'));
      }

      final cachedJsonValue = cacheModel.value;
      final jsonValue = jsonDecode(cachedJsonValue);

      final result = JsonParser.parseList(fromJson, jsonValue);

      return result;
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<bool, Exception>> putItem<T>(String key, IModel<T> item, {Duration? duration}) async {
    try {
      final cacheModel = CacheModel(
        expiration: duration == null ? NonExpirable() : Expirable(DateTime.now().add(duration)),
        value: json.encode(item.toJson()),
      );

      await _cacheDatabaseManager.putItem(key, json.encode(cacheModel.toJson()));
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

  Future<bool> _validateCache(String key, CacheModel? model) async {
    if (model == null) {
      return false;
    }

    switch (model.expiration) {
      case Expirable(expiration: final expiration):
        if (expiration.isBefore(DateTime.now())) {
          await removeItem(key);
          return false;
        }
        return true;
      case NonExpirable():
        return true;
    }
  }

  @override
  Future<Result<bool, Exception>> putItems<T>(String key, List<IModel<T>> item, {Duration? duration}) async {
    try {
      final cacheModel = CacheModel(
        expiration: duration == null ? NonExpirable() : Expirable(DateTime.now().add(duration)),
        value: json.encode(item.map((item) => item.toJson()).toList()),
      );

      await _cacheDatabaseManager.putItem(key, json.encode(cacheModel.toJson()));
      return const Success(true);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }
}
