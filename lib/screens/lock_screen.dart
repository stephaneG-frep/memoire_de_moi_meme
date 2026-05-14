import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({super.key, required this.onUnlocked});

  final VoidCallback onUnlocked;

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final _pinCtrl = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _pinCtrl.dispose();
    super.dispose();
  }

  Future<void> _unlockWithBiometric() async {
    final ok = await context.read<SettingsProvider>().tryBiometricAuth();
    if (ok) widget.onUnlocked();
  }

  void _unlockWithPin() {
    final settings = context.read<SettingsProvider>();
    final pin = settings.pin;
    if (pin == null || pin.isEmpty || _pinCtrl.text.trim() == pin) {
      widget.onUnlocked();
      return;
    }
    setState(() => _error = 'PIN incorrect');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_outline, size: 56),
              const SizedBox(height: 10),
              Text(
                'MoodBook verrouillé',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _pinCtrl,
                maxLength: 6,
                obscureText: true,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Code PIN',
                  errorText: _error,
                ),
              ),
              const SizedBox(height: 10),
              FilledButton(
                onPressed: _unlockWithPin,
                child: const Text('Déverrouiller'),
              ),
              TextButton.icon(
                onPressed: _unlockWithBiometric,
                icon: const Icon(Icons.fingerprint),
                label: const Text('Biométrie'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
