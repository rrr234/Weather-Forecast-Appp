import 'package:flutter/material.dart';

import 'services/password_api.dart';

class ApiPage extends StatefulWidget {
  const ApiPage({super.key});

  @override
  State<ApiPage> createState() => _ApiPageState();
}

class _ApiPageState extends State<ApiPage> {
  int length = 12;
  bool letters = true;
  bool numbers = true;
  bool symbols = false;
  PasswordResult? _result;

  void _generate() {
    setState(() => _result = null);
    final api = PasswordApi();
    final res = api.generate(length: length, letters: letters, numbers: numbers, symbols: symbols);
    setState(() => _result = res);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Генератор паролей (API)')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Text('Длина:'),
                const SizedBox(width: 12),
                Expanded(
                  child: Slider(
                    value: length.toDouble(),
                    min: 6,
                    max: 32,
                    divisions: 26,
                    label: length.toString(),
                    onChanged: (v) => setState(() => length = v.toInt()),
                  ),
                ),
                Text('$length'),
              ],
            ),

            SwitchListTile(
              title: const Text('Буквы'),
              value: letters,
              activeThumbColor: Theme.of(context).colorScheme.primary,
              onChanged: (v) => setState(() => letters = v),
            ),
            SwitchListTile(
              title: const Text('Цифры'),
              value: numbers,
              activeThumbColor: Theme.of(context).colorScheme.primary,
              onChanged: (v) => setState(() => numbers = v),
            ),
            SwitchListTile(
              title: const Text('Символы'),
              value: symbols,
              activeThumbColor: Theme.of(context).colorScheme.primary,
              onChanged: (v) => setState(() => symbols = v),
            ),

            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _generate,
                child: const Text('Сгенерировать пароль'),
              ),
            ),

            const SizedBox(height: 20),
            if (_result != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Сгенерированный пароль', style: TextStyle(fontSize: 18)),
                      const SizedBox(height: 8),
                      SelectableText(_result!.password, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Text('Оценка: ${_result!.strength}', style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
