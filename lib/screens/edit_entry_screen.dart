import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/journal_entry.dart';
import '../providers/journal_provider.dart';
import '../widgets/mood_selector.dart';

class EditEntryScreen extends StatefulWidget {
  const EditEntryScreen({super.key, this.entry});

  final JournalEntry? entry;

  @override
  State<EditEntryScreen> createState() => _EditEntryScreenState();
}

class _EditEntryScreenState extends State<EditEntryScreen> {
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();
  final _tagsCtrl = TextEditingController();
  Mood _selectedMood = Mood.calme;
  String? _imagePath;
  bool _isCapsule = false;
  DateTime? _unlockDate;

  @override
  void initState() {
    super.initState();
    final e = widget.entry;
    if (e != null) {
      _titleCtrl.text = e.title;
      _contentCtrl.text = e.content;
      _tagsCtrl.text = e.tags.join(', ');
      _selectedMood = e.mood;
      _imagePath = e.imagePath;
      _isCapsule = e.isTimeCapsule;
      _unlockDate = e.unlockDate;
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    _tagsCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (file == null) return;
    setState(() => _imagePath = file.path);
  }

  Future<void> _pickUnlockDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: DateTime(now.year + 10),
      initialDate: now.add(const Duration(days: 1)),
    );
    if (date != null) setState(() => _unlockDate = date);
  }

  Future<void> _save() async {
    if (_titleCtrl.text.trim().isEmpty || _contentCtrl.text.trim().isEmpty) {
      return;
    }
    final tags = _tagsCtrl.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList();

    final provider = context.read<JournalProvider>();
    if (widget.entry == null) {
      final entry = JournalEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleCtrl.text.trim(),
        content: _contentCtrl.text.trim(),
        createdAt: DateTime.now(),
        mood: _selectedMood,
        tags: tags,
        imagePath: _imagePath,
        isTimeCapsule: _isCapsule,
        unlockDate: _isCapsule ? _unlockDate : null,
      );
      await provider.addEntry(entry);
    } else {
      final updated = widget.entry!.copyWith(
        title: _titleCtrl.text.trim(),
        content: _contentCtrl.text.trim(),
        mood: _selectedMood,
        tags: tags,
        imagePath: _imagePath,
        clearImage: _imagePath == null,
        isTimeCapsule: _isCapsule,
        unlockDate: _isCapsule ? _unlockDate : null,
        clearUnlockDate: !_isCapsule,
      );
      await provider.updateEntry(updated);
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.entry == null ? 'Nouvelle entrée' : 'Modifier l\'entrée',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(labelText: 'Titre'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _contentCtrl,
              maxLines: 8,
              decoration: const InputDecoration(
                labelText: 'Que ressens-tu aujourd\'hui ?',
              ),
            ),
            const SizedBox(height: 12),
            MoodSelector(
              selected: _selectedMood,
              onChanged: (m) => setState(() => _selectedMood = m),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _tagsCtrl,
              decoration: const InputDecoration(
                labelText: 'Tags (séparés par des virgules)',
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image_outlined),
                  label: Text(
                    _imagePath == null
                        ? 'Ajouter une image'
                        : 'Changer l\'image',
                  ),
                ),
                if (_imagePath != null)
                  TextButton(
                    onPressed: () => setState(() => _imagePath = null),
                    child: const Text('Retirer'),
                  ),
              ],
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _isCapsule,
              title: const Text('Capsule temporelle'),
              onChanged: (v) => setState(() => _isCapsule = v),
            ),
            if (_isCapsule)
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: _pickUnlockDate,
                    icon: const Icon(Icons.lock_clock_outlined),
                    label: const Text('Date de déverrouillage'),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _unlockDate == null
                        ? 'Aucune date'
                        : '${_unlockDate!.day}/${_unlockDate!.month}/${_unlockDate!.year}',
                  ),
                ],
              ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save_outlined),
              label: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }
}
