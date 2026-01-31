import 'dart:math';

import 'package:flutter/material.dart';

class PasswordToolsPage extends StatefulWidget {
  const PasswordToolsPage({super.key});

  @override
  State<PasswordToolsPage> createState() => _PasswordToolsPageState();
}

class _PasswordToolsPageState extends State<PasswordToolsPage> {
  final _controller = TextEditingController();
  double? _entropy;
  String? _strength;

  void _check() {
    final pwd = _controller.text;
    if (pwd.isEmpty) return;
    final charsetSize = _estimateCharsetSize(pwd);
    final entropy = pwd.length * (log(charsetSize) / ln2);
    final strength = _classify(entropy, pwd);
    setState(() {
      _entropy = entropy;
      _strength = strength;
    });
  }

  int _estimateCharsetSize(String pwd) {
    var size = 0;
    if (RegExp(r'[a-z]').hasMatch(pwd)) size += 26;
    if (RegExp(r'[A-Z]').hasMatch(pwd)) size += 26;
    if (RegExp(r'[0-9]').hasMatch(pwd)) size += 10;
    if (RegExp(r'[!@#\u0024%\^&\*()_+\-=[\]{};:\\",.<>/?]').hasMatch(pwd)) size += 32;
    if (size == 0) size = 1;
    return size;
  }

  String _classify(double entropy, String pwd) {
    if (pwd.length < 6 || entropy < 28) return 'Weak';
    if (entropy < 50) return 'Medium';
    return 'Strong';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Инструменты пароля')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Введите пароль для проверки'),
              obscureText: true,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _check,
                    child: const Text('Проверить пароль'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_entropy != null && _strength != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Энтропия: ${_entropy!.toStringAsFixed(1)} bits'),
                      const SizedBox(height: 8),
                      Text('Оценка: $_strength'),
                      const SizedBox(height: 8),
                      if (_strength == 'Weak') const Text('Совет: увеличьте длину и добавьте разные типы символов.'),
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
