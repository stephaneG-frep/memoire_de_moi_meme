import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/journal_entry.dart';
import '../providers/journal_provider.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<JournalProvider>();
    final freqMood = provider.mostFrequentMood;
    final moodCounts = <Mood, int>{};
    for (final mood in Mood.values) {
      moodCounts[mood] = provider.entries.where((e) => e.mood == mood).length;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Statistiques')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              title: const Text('Nombre total d\'entrées'),
              trailing: Text('${provider.totalEntries}'),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('Humeur la plus fréquente'),
              trailing: Text(
                freqMood == null
                    ? '-'
                    : '${moodMeta[freqMood]!.emoji} ${moodMeta[freqMood]!.label}',
              ),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('Nombre de jours écrits'),
              trailing: Text('${provider.uniqueDaysWritten}'),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 260,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: BarChart(
                  BarChartData(
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 24,
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, _) {
                            final mood = Mood.values[value.toInt()];
                            return Text(moodMeta[mood]!.emoji);
                          },
                        ),
                      ),
                    ),
                    barGroups: List.generate(Mood.values.length, (i) {
                      final mood = Mood.values[i];
                      return BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: moodCounts[mood]!.toDouble(),
                            color: moodMeta[mood]!.color,
                            width: 16,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
