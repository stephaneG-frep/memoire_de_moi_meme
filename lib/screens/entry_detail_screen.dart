import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/journal_entry.dart';

class EntryDetailScreen extends StatelessWidget {
  const EntryDetailScreen({super.key, required this.entry});

  final JournalEntry entry;

  @override
  Widget build(BuildContext context) {
    final mood = moodMeta[entry.mood]!;
    return Scaffold(
      appBar: AppBar(title: Text(entry.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            DateFormat(
              'EEEE dd MMMM yyyy, HH:mm',
              'fr_FR',
            ).format(entry.createdAt),
          ),
          const SizedBox(height: 8),
          Chip(
            label: Text('${mood.emoji} ${mood.label}'),
            backgroundColor: mood.color.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 16),
          Text(entry.content, style: Theme.of(context).textTheme.bodyLarge),
          if (entry.tags.isNotEmpty) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: entry.tags
                  .map((t) => Chip(label: Text('#$t')))
                  .toList(),
            ),
          ],
          if (entry.imagePath != null) ...[
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(File(entry.imagePath!), fit: BoxFit.cover),
            ),
          ],
        ],
      ),
    );
  }
}
