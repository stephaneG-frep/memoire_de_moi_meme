import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../models/journal_entry.dart';

class JournalProvider extends ChangeNotifier {
  JournalProvider(this._box) {
    _entries = _box.values.cast<JournalEntry>().toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  final Box<JournalEntry> _box;
  late List<JournalEntry> _entries;

  UnmodifiableListView<JournalEntry> get entries =>
      UnmodifiableListView(_entries);

  List<JournalEntry> get latestEntries => _entries.take(5).toList();

  int get totalEntries => _entries.length;

  int get uniqueDaysWritten {
    final days = _entries
        .map((e) => DateFormat('yyyy-MM-dd').format(e.createdAt))
        .toSet();
    return days.length;
  }

  Mood? get mostFrequentMood {
    if (_entries.isEmpty) return null;
    final counts = <Mood, int>{};
    for (final entry in _entries) {
      counts.update(entry.mood, (value) => value + 1, ifAbsent: () => 1);
    }
    return counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }

  List<JournalEntry> entriesByDate(DateTime date) {
    return _entries.where((entry) {
      return entry.createdAt.year == date.year &&
          entry.createdAt.month == date.month &&
          entry.createdAt.day == date.day;
    }).toList();
  }

  List<JournalEntry> get timeCapsules =>
      _entries.where((e) => e.isTimeCapsule).toList();

  Future<void> addEntry(JournalEntry entry) async {
    final existingIndex = _entries.indexWhere((e) => e.id == entry.id);
    if (existingIndex != -1) return;
    await _box.put(entry.id, entry);
    _entries.insert(0, entry);
    _entries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    notifyListeners();
  }

  Future<void> updateEntry(JournalEntry updated) async {
    final index = _entries.indexWhere((e) => e.id == updated.id);
    if (index == -1) return;
    await _box.put(updated.id, updated);
    _entries[index] = updated;
    _entries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    notifyListeners();
  }

  Future<void> deleteEntry(String id) async {
    await _box.delete(id);
    _entries.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  String get todaySummary {
    final todayEntries = entriesByDate(DateTime.now());
    if (todayEntries.isEmpty) return 'Pas encore d\'entrée aujourd\'hui.';
    return 'Aujourd\'hui: ${todayEntries.length} note(s), humeur dominante ${moodMeta[todayEntries.first.mood]!.emoji}.';
  }
}
