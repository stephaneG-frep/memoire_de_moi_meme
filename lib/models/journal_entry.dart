import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

enum Mood {
  heureux,
  calme,
  triste,
  enColere,
  fatigue,
  inspire,
  stresse,
  reconnaissant,
}

class MoodData {
  final String label;
  final String emoji;
  final Color color;

  const MoodData({
    required this.label,
    required this.emoji,
    required this.color,
  });
}

const Map<Mood, MoodData> moodMeta = {
  Mood.heureux: MoodData(
    label: 'Heureux',
    emoji: '😊',
    color: Color(0xFFF6B73C),
  ),
  Mood.calme: MoodData(label: 'Calme', emoji: '🌿', color: Color(0xFF62B36F)),
  Mood.triste: MoodData(
    label: 'Triste',
    emoji: '🌧️',
    color: Color(0xFF5D8FD8),
  ),
  Mood.enColere: MoodData(
    label: 'En colère',
    emoji: '🔥',
    color: Color(0xFFE3654D),
  ),
  Mood.fatigue: MoodData(
    label: 'Fatigué',
    emoji: '🌙',
    color: Color(0xFF7A72B8),
  ),
  Mood.inspire: MoodData(
    label: 'Inspiré',
    emoji: '✨',
    color: Color(0xFFF191D3),
  ),
  Mood.stresse: MoodData(
    label: 'Stressé',
    emoji: '🌪️',
    color: Color(0xFF9D7A67),
  ),
  Mood.reconnaissant: MoodData(
    label: 'Reconnaissant',
    emoji: '💛',
    color: Color(0xFFE8AF2F),
  ),
};

class JournalEntry {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final Mood mood;
  final List<String> tags;
  final String? imagePath;
  final bool isTimeCapsule;
  final DateTime? unlockDate;

  const JournalEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.mood,
    required this.tags,
    this.imagePath,
    required this.isTimeCapsule,
    this.unlockDate,
  });

  Color get moodColor => moodMeta[mood]!.color;

  bool get isLocked {
    if (!isTimeCapsule || unlockDate == null) return false;
    return DateTime.now().isBefore(unlockDate!);
  }

  JournalEntry copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? createdAt,
    Mood? mood,
    List<String>? tags,
    String? imagePath,
    bool clearImage = false,
    bool? isTimeCapsule,
    DateTime? unlockDate,
    bool clearUnlockDate = false,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      mood: mood ?? this.mood,
      tags: tags ?? this.tags,
      imagePath: clearImage ? null : (imagePath ?? this.imagePath),
      isTimeCapsule: isTimeCapsule ?? this.isTimeCapsule,
      unlockDate: clearUnlockDate ? null : (unlockDate ?? this.unlockDate),
    );
  }
}

class JournalEntryAdapter extends TypeAdapter<JournalEntry> {
  @override
  final int typeId = 0;

  @override
  JournalEntry read(BinaryReader reader) {
    final count = reader.readByte();
    final map = <int, dynamic>{};
    for (var i = 0; i < count; i++) {
      map[reader.readByte()] = reader.read();
    }
    return JournalEntry(
      id: map[0] as String,
      title: map[1] as String,
      content: map[2] as String,
      createdAt: map[3] as DateTime,
      mood: Mood.values[map[4] as int],
      tags: (map[5] as List).cast<String>(),
      imagePath: map[6] as String?,
      isTimeCapsule: map[7] as bool,
      unlockDate: map[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, JournalEntry obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.mood.index)
      ..writeByte(5)
      ..write(obj.tags)
      ..writeByte(6)
      ..write(obj.imagePath)
      ..writeByte(7)
      ..write(obj.isTimeCapsule)
      ..writeByte(8)
      ..write(obj.unlockDate);
  }
}
