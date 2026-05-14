import 'dart:math';

import 'package:flutter/material.dart';

class QuoteCard extends StatelessWidget {
  const QuoteCard({super.key});

  final _quotes = const [
    'Chaque mot est une graine de demain.',
    'Tu avances même dans le silence.',
    'Écrire, c\'est respirer en conscience.',
    'Un petit pas intime vaut une grande promesse.',
    'Aujourd\'hui compte, même doucement.',
  ];

  @override
  Widget build(BuildContext context) {
    final quote = _quotes[Random().nextInt(_quotes.length)];
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: isDark
                ? const [Color(0xFF2A3E63), Color(0xFF314875)]
                : const [Color(0xFFF9D5E8), Color(0xFFD8EDFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.auto_awesome,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(quote, style: Theme.of(context).textTheme.bodyLarge),
            ),
          ],
        ),
      ),
    );
  }
}
