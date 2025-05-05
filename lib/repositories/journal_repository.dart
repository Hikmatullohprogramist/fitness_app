import 'package:hive/hive.dart';
import '../models/journal_entry.dart';
import 'base_repository.dart';

class JournalRepository implements BaseRepository<JournalEntry> {
  final Box<List> _box;

  JournalRepository(this._box);

  @override
  Future<void> save(JournalEntry entry) async {
    final entries = await getAll();
    entries.add(entry);
    await _box.put('journal_entries', entries.map((e) => e.toJson()).toList());
  }

  @override
  Future<JournalEntry?> get(String id) async {
    final entries = await getAll();
    return entries.firstWhere((e) => e.date.toIso8601String() == id);
  }

  @override
  Future<List<JournalEntry>> getAll() async {
    final data = _box.get('journal_entries');
    if (data == null) return [];
    return (data as List).map((e) => JournalEntry.fromJson(e)).toList();
  }

  @override
  Future<void> update(JournalEntry entry) async {
    final entries = await getAll();
    final index = entries.indexWhere((e) => e.date == entry.date);
    if (index != -1) {
      entries[index] = entry;
      await _box.put(
          'journal_entries', entries.map((e) => e.toJson()).toList());
    }
  }

  @override
  Future<void> delete(String id) async {
    final entries = await getAll();
    entries.removeWhere((e) => e.date.toIso8601String() == id);
    await _box.put('journal_entries', entries.map((e) => e.toJson()).toList());
  }
}
