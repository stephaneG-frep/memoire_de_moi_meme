import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/journal_provider.dart';
import '../widgets/entry_card.dart';
import '../widgets/quote_card.dart';
import 'calendar_screen.dart';
import 'edit_entry_screen.dart';
import 'entry_detail_screen.dart';
import 'settings_screen.dart';
import 'stats_screen.dart';
import 'time_capsules_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<JournalProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('MoodBook'),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CalendarScreen()),
            ),
            icon: const Icon(Icons.calendar_month_outlined),
          ),
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const StatsScreen()),
            ),
            icon: const Icon(Icons.insights_outlined),
          ),
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TimeCapsulesScreen()),
            ),
            icon: const Icon(Icons.lock_clock_outlined),
          ),
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EditEntryScreen()),
        ),
        icon: const Icon(Icons.edit_note),
        label: const Text('Nouvelle entrée'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? const [
                    Color(0xFF0E1526),
                    Color(0xFF172846),
                    Color(0xFF1B3054),
                  ]
                : const [
                    Color(0xFFFFF0E6),
                    Color(0xFFF9E3F6),
                    Color(0xFFE3F0FF),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            QuoteCard(),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.today_outlined),
                title: const Text('Résumé du jour'),
                subtitle: Text(provider.todaySummary),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Dernières entrées',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            if (provider.latestEntries.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Aucune entrée pour l\'instant. Commence ton premier souvenir.',
                  ),
                ),
              )
            else
              ...provider.latestEntries.map(
                (entry) => EntryCard(
                  entry: entry,
                  onTap: () async {
                    if (entry.isLocked) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Capsule encore verrouillée.'),
                        ),
                      );
                      return;
                    }
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EntryDetailScreen(entry: entry),
                      ),
                    );
                  },
                  onDelete: () => provider.deleteEntry(entry.id),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
