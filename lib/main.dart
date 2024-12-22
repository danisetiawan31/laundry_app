import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:laundry_app/firebase_options.dart';
import 'package:laundry_app/login_screen.dart';
import 'owner_profile.dart'; // Halaman profil owner
import 'user_home_page.dart'; // Halaman home untuk user
import 'owner_home_page.dart'; // Halaman home untuk owner

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shabrina Laundry',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/login', // Rute awal ke halaman login
      routes: {
        '/login': (context) => const LoginScreen(),
        '/userHome': (context) => const UserHomePage(),
        '/ownerHome': (context) => const OwnerHomePage(),
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}
