import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OwnerHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Owner Home Page"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          "Welcome, Owner!",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
