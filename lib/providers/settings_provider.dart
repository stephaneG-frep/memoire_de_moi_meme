import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:local_auth/local_auth.dart';

class SettingsProvider extends ChangeNotifier {
  SettingsProvider(this._box);

  final Box _box;
  final LocalAuthentication _auth = LocalAuthentication();

  bool get securityEnabled =>
      _box.get('securityEnabled', defaultValue: false) as bool;
  String? get pin => _box.get('pin') as String?;
  bool get darkMode => _box.get('darkMode', defaultValue: false) as bool;

  Future<void> setSecurityEnabled(bool enabled) async {
    await _box.put('securityEnabled', enabled);
    notifyListeners();
  }

  Future<void> setPin(String value) async {
    await _box.put('pin', value);
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    await _box.put('darkMode', value);
    notifyListeners();
  }

  Future<bool> tryBiometricAuth() async {
    final canCheck = await _auth.canCheckBiometrics;
    final supported = await _auth.isDeviceSupported();
    if (!canCheck || !supported) return false;
    try {
      return await _auth.authenticate(
        localizedReason: 'Déverrouiller MoodBook',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (_) {
      return false;
    }
  }
}
