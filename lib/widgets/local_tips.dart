import 'package:flutter/material.dart';

// No form values, controllers, networking, or external services enter this feature.
class LocalTipService {
  static const category = 'password_help';
  static const tips = <String, List<String>>{
    'password_help': [
      'Use a unique password for each account. A password manager can help you remember it.',
      'A longer passphrase can be easier to remember. Avoid names and birthdays.',
    ],
  };
  Future<String> getTip({bool simulateFailure = false}) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (simulateFailure) throw StateError('Demo failure');
    return tips[category]!.first;
  }
}

class LocalTips extends StatefulWidget {
  const LocalTips({super.key});
  @override
  State<LocalTips> createState() => _LocalTipsState();
}

class _LocalTipsState extends State<LocalTips> {
  final _service = LocalTipService();
  bool _loading = false, _failNext = false;
  String? _tip, _error;
  Future<void> _load({bool retry = false}) async {
    final fail = !retry && _failNext;
    setState(() {
      _loading = true;
      _tip = null;
      _error = null;
      _failNext = false;
    });
    try {
      final tip = await _service.getTip(simulateFailure: fail);
      if (!mounted) return;
      setState(() => _tip = tip);
    } catch (_) {
      if (!mounted) return;
      setState(
        () => _error = 'The demo tip could not load. Tap Retry to try again.',
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'A little guidance',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const Text(
            'Offline guidance only. Tips do not check or approve your signup.',
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Simulate next tip failure'),
            value: _failNext,
            onChanged: _loading ? null : (v) => setState(() => _failNext = v),
          ),
          OutlinedButton(
            onPressed: _loading ? null : _load,
            child: const Text('Get a signup tip'),
          ),
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(8),
              child: LinearProgressIndicator(),
            ),
          if (_tip != null) ...[
            const Text(
              'Preset demo tip',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(_tip!),
          ],
          if (_error != null) ...[
            Text(_error!),
            TextButton(
              onPressed: _loading ? null : () => _load(retry: true),
              child: const Text('Retry'),
            ),
          ],
        ],
      ),
    ),
  );
}
