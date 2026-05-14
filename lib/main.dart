import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'models/journal_entry.dart';
import 'providers/journal_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/home_screen.dart';
import 'screens/lock_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR');
  await Hive.initFlutter();

  Hive.registerAdapter(JournalEntryAdapter());

  final journalBox = await Hive.openBox<JournalEntry>('journal_entries');
  final settingsBox = await Hive.openBox('app_settings');

  runApp(MoodBookApp(journalBox: journalBox, settingsBox: settingsBox));
}

class MoodBookApp extends StatelessWidget {
  const MoodBookApp({
    super.key,
    required this.journalBox,
    required this.settingsBox,
  });

  final Box<JournalEntry> journalBox;
  final Box settingsBox;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => JournalProvider(journalBox)),
        ChangeNotifierProvider(create: (_) => SettingsProvider(settingsBox)),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return MaterialApp(
            title: 'MoodBook',
            debugShowCheckedModeBanner: false,
            themeMode: settings.darkMode ? ThemeMode.dark : ThemeMode.light,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            home: _AppGate(settings: settings),
          );
        },
      ),
    );
  }
}

class _AppGate extends StatefulWidget {
  const _AppGate({required this.settings});

  final SettingsProvider settings;

  @override
  State<_AppGate> createState() => _AppGateState();
}

class _AppGateState extends State<_AppGate> {
  bool _unlocked = false;

  @override
  void initState() {
    super.initState();
    _unlocked = !widget.settings.securityEnabled;
  }

  @override
  void didUpdateWidget(covariant _AppGate oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.settings.securityEnabled) _unlocked = true;
  }

  @override
  Widget build(BuildContext context) {
    if (!_unlocked && widget.settings.securityEnabled) {
      return LockScreen(onUnlocked: () => setState(() => _unlocked = true));
    }
    return const HomeScreen();
  }
}
