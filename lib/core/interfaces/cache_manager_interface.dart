import 'package:flutter_example/core/models/result_model.dart';

abstract class ICacheManager {
  /// If [duration] is null, the item will be stored indefinitely.
  Future<Result<bool, Exception>> putItem<T>(String key, T item, {Duration? duration});

  Future<Result<T, Exception>> getItem<T>(String key);

  Future<Result<List<T>, Exception>> getItems<T>(String key);

  Future<Result<bool, Exception>> removeItem(String key);

  Future<Result<bool, Exception>> clearAll();
}
