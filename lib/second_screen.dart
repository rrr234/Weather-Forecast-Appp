import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Второй экран')),
      body: Center(
        child: ElevatedButton(
          child: const Text('Назад на главный экран'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
