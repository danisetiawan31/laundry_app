import 'package:flutter/material.dart';

class Accorder extends StatelessWidget {
  const Accorder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Halaman Accorder'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Ini adalah halaman Accorder',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
