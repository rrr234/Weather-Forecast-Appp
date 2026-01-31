import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'password_tools_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
      home: const GeneratorPage(),
    );
  }
}

/// ---------- ЭКРАН 1 ----------
class GeneratorPage extends StatefulWidget {
  const GeneratorPage({super.key});

  @override
  State<GeneratorPage> createState() => _GeneratorPageState();
}

class _GeneratorPageState extends State<GeneratorPage> {
  int length = 12;
  bool letters = true;
  bool numbers = true;
  bool symbols = false;

  String generatePassword() {
    const l = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const n = '0123456789';
    const s = '!@#\$%^&*()_+-=[]{};:,.<>?';

    String chars = '';
    if (letters) chars += l;
    if (numbers) chars += n;
    if (symbols) chars += s;

    final random = Random();
    return List.generate(
      length,
      (i) => chars[random.nextInt(chars.length)],
    ).join();
  }

  void goToResult() {
    if (!letters && !numbers && !symbols) return;

    final password = generatePassword();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultPage(password: password),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
              Color(0xFF0F3460),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  '🔐 Генератор паролей',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ),

              Expanded(
                child: Card(
                  margin: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 12,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text('Длина: $length'),
                        Slider(
                          value: length.toDouble(),
                          min: 6,
                          max: 32,
                          divisions: 26,
                          onChanged: (v) =>
                              setState(() => length = v.toInt()),
                        ),

                        SwitchListTile(
                          title: const Text('Буквы'),
                          value: letters,
                          activeThumbColor: Colors.deepPurple,
                          onChanged: (v) =>
                              setState(() => letters = v),
                        ),
                        SwitchListTile(
                          title: const Text('Цифры'),
                          value: numbers,
                          activeThumbColor: Colors.deepPurple,
                          onChanged: (v) =>
                              setState(() => numbers = v),
                        ),
                        SwitchListTile(
                          title: const Text('Символы'),
                          value: symbols,
                          activeThumbColor: Colors.deepPurple,
                          onChanged: (v) =>
                              setState(() => symbols = v),
                        ),

                        const Spacer(),

                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: goToResult,
                            child: const Text(
                              'СГЕНЕРИРОВАТЬ',
                              style: TextStyle(
                                fontSize: 16,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const PasswordToolsPage()),
                              );
                            },
                            child: const Text('Инструменты пароля'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ---------- ЭКРАН 2 ----------
class ResultPage extends StatelessWidget {
  final String password;
  const ResultPage({super.key, required this.password});

  void copy(BuildContext context) {
    Clipboard.setData(ClipboardData(text: password));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Скопировано 📋')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0F3460),
              Color(0xFF533483),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),

              const Spacer(),

              Card(
                margin: const EdgeInsets.all(24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 16,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Твой пароль',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 12),
                      SelectableText(
                        password,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () => copy(context),
                        icon: const Icon(Icons.copy),
                        label: const Text('Скопировать'),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
