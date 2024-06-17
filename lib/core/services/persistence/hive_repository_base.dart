import 'package:flutter_example/core/interfaces/repository_async_interface.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveRepositoryBase implements IRepositoryAsync {
  late final String _key;

  late final Box<String> _box;

  HiveRepositoryBase(String key) {
    _key = key;
  }

  @override
  Future<void> addItems(List<String> items) async {
    await _box.addAll(items);
  }

  @override
  Future<String?> getItem(String key) async {
    return _box.get(key);
  }

  @override
  Future<void> putItem(String key, String item) async {
    await _box.put(key, item);
  }

  @override
  Future<void> removeItem(String key) async {
    await _box.delete(key);
  }

  @override
  Future<List<String>?> getValues() async {
    return _box.values.toList();
  }

  @override
  Future<void> clearAll() async {
    await _box.clear();
  }

  Future<void> init() async {
    _box = await Hive.openBox<String>(_key);
  }
}
