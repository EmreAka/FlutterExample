abstract class ICacheManager {
  Future<void> putItem<T>(String key, T item, Duration duration);

  Future<T?> getItem<T>(String key);

  Future<List<T>?> getItems<T>(String key);

  Future<void> removeItem(String key);

  Future<void> clearAll();
}