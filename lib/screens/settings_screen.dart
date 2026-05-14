import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _pinCtrl = TextEditingController();

  @override
  void dispose() {
    _pinCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            value: settings.darkMode,
            title: const Text('Mode sombre'),
            onChanged: settings.setDarkMode,
          ),
          SwitchListTile(
            value: settings.securityEnabled,
            title: const Text('Activer la sécurité (PIN/Biométrie)'),
            onChanged: settings.setSecurityEnabled,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _pinCtrl,
            keyboardType: TextInputType.number,
            maxLength: 6,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Définir un PIN (4 à 6 chiffres)',
            ),
          ),
          FilledButton(
            onPressed: () async {
              final pin = _pinCtrl.text.trim();
              if (pin.length >= 4) {
                await settings.setPin(pin);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('PIN enregistré.')),
                  );
                }
              }
            },
            child: const Text('Enregistrer le PIN'),
          ),
        ],
      ),
    );
  }
}
