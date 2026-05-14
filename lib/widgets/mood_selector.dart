import 'package:flutter/material.dart';

import '../models/journal_entry.dart';

class MoodSelector extends StatelessWidget {
  const MoodSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final Mood selected;
  final ValueChanged<Mood> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: Mood.values.map((mood) {
        final data = moodMeta[mood]!;
        final isSelected = selected == mood;
        return ChoiceChip(
          label: Text('${data.emoji} ${data.label}'),
          selected: isSelected,
          onSelected: (_) => onChanged(mood),
          selectedColor: data.color.withValues(alpha: 0.22),
        );
      }).toList(),
    );
  }
}
