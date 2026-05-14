import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/journal_provider.dart';
import 'entry_detail_screen.dart';

class TimeCapsulesScreen extends StatelessWidget {
  const TimeCapsulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final capsules = context.watch<JournalProvider>().timeCapsules;

    return Scaffold(
      appBar: AppBar(title: const Text('Capsules temporelles')),
      body: capsules.isEmpty
          ? const Center(child: Text('Aucune capsule temporelle.'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: capsules.length,
              itemBuilder: (context, index) {
                final e = capsules[index];
                if (e.isLocked) {
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.lock_outline),
                      title: Text(e.title),
                      subtitle: Text(
                        'Déverrouillage: ${DateFormat('dd/MM/yyyy').format(e.unlockDate!)}',
                      ),
                    ),
                  );
                }
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.lock_open_outlined),
                    title: Text(e.title),
                    subtitle: const Text('Capsule ouverte'),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EntryDetailScreen(entry: e),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
