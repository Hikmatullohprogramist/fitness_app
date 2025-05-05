abstract class BaseRepository<T> {
  Future<void> save(T item);
  Future<T?> get(String id);
  Future<List<T>> getAll();
  Future<void> update(T item);
  Future<void> delete(String id);
}
