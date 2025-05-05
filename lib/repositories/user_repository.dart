import 'package:hive/hive.dart';
import '../models/user.dart';
import 'base_repository.dart';

class UserRepository implements BaseRepository<User> {
  final Box<Map<String, dynamic>> _box;

  UserRepository(this._box);

  @override
  Future<void> save(User user) async {
    await _box.put('current_user', user.toJson());
  }

  @override
  Future<User?> get(String id) async {
    final data = _box.get('current_user');
    if (data == null) return null;
    return User.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<List<User>> getAll() async {
    final data = _box.get('current_user');
    if (data == null) return [];
    return [User.fromJson(data)];
  }

  @override
  Future<void> update(User user) async {
    await save(user);
  }

  @override
  Future<void> delete(String id) async {
    await _box.delete('current_user');
  }
}
