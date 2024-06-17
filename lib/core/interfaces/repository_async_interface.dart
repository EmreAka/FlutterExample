abstract class IRepositoryAsync {
  Future<void> clearAll();

  Future<void> addItems(List<String> items);

  Future<String?> getItem(String key);

  Future<List<String>?> getValues();

  Future<void> putItem(String key, String item);

  Future<void> removeItem(String key);
}