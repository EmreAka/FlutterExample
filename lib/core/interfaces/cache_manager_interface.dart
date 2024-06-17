import 'package:flutter_example/core/models/model_interface.dart';
import 'package:flutter_example/core/models/result_model.dart';

abstract class ICacheManager {
  /// If [duration] is null, the item will be stored indefinitely.
  Future<Result<bool, Exception>> putItem<T>(String key, IModel<T> item, {Duration? duration});
  
  Future<Result<bool, Exception>> putItems<T>(String key, List<IModel<T>> item, {Duration? duration});

  Future<Result<T, Exception>> getItem<T>(String key, T Function(Map<String, Object?>) fromJson);

  Future<Result<List<T>, Exception>> getItems<T>(String key, T Function(Map<String, Object?>) fromJson);

  Future<Result<bool, Exception>> removeItem(String key);

  Future<Result<bool, Exception>> clearAll();
}
