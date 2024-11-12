import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OwnerHomePage extends StatelessWidget {
  const OwnerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Owner Home Page"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          "Welcome, Owner!",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
