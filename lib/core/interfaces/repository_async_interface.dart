abstract class IRepositoryAsync<T> {
  Future<void> clearAll();

  Future<void> addItems(List<T> items);

  Future<T?> getItem(String key);

  Future<List<T>?> getValues();

  Future<void> putItem(String key, T item);

  Future<void> removeItem(String key);
}