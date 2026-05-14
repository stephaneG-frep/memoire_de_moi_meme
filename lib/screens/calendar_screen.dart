import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../providers/journal_provider.dart';
import '../widgets/emotional_calendar_marker.dart';
import '../widgets/entry_card.dart';
import 'entry_detail_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selected = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<JournalProvider>();
    final selectedEntries = provider.entriesByDate(_selected);
    return Scaffold(
      appBar: AppBar(title: const Text('Calendrier émotionnel')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2000),
            lastDay: DateTime(2100),
            focusedDay: _selected,
            selectedDayPredicate: (d) => isSameDay(d, _selected),
            onDaySelected: (day, _) => setState(() => _selected = day),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, _) {
                final dayEntries = provider.entriesByDate(date);
                if (dayEntries.isEmpty) return const SizedBox.shrink();
                return EmotionalCalendarMarker(
                  colors: dayEntries.map((e) => e.moodColor).toList(),
                );
              },
            ),
          ),
          const Divider(),
          Expanded(
            child: selectedEntries.isEmpty
                ? const Center(child: Text('Aucune entrée ce jour-là.'))
                : ListView.builder(
                    itemCount: selectedEntries.length,
                    itemBuilder: (context, index) {
                      final entry = selectedEntries[index];
                      return EntryCard(
                        entry: entry,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EntryDetailScreen(entry: entry),
                          ),
                        ),
                        onDelete: () => provider.deleteEntry(entry.id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
