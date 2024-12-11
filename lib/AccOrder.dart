import 'package:flutter/material.dart';

class Accorder extends StatelessWidget {
  const Accorder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Halaman Accorder'),
        centerTitle: true,
      ),
      body: Center(
        child: const Text(
          'Ini adalah halaman Accorder',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
