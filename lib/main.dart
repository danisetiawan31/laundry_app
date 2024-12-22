import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      home: AuthWrapper(),
      // initialRoute: '/login', // Rute awal ke halaman login
      // routes: {
      //   '/login': (context) => const LoginScreen(),
      //   '/userHome': (context) => const UserHomePage(),
      //   '/ownerHome': (context) => const OwnerHomePage(),
      //   '/profile': (context) => ProfilePage(),
      // },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;

          if (user == null) {
            // If not logged in, show StartingPage
            return LoginScreen();
          } else {
            String loginMethod = user.providerData.isNotEmpty
                ? user.providerData[0].providerId == 'google.com'
                    ? 'Google'
                    : 'Email'
                : 'Email';
            // If logged in, retrieve additional user data from Firestore
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .get(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.done) {
                  if (userSnapshot.hasData && userSnapshot.data!.exists) {
                    // Get the user data as a map
                    var userData =
                        userSnapshot.data!.data() as Map<String, dynamic>;
                    String? username = userData['username'] ?? user.displayName;
                    String role = userData['role'];
                    if (role == "owner") {
                      return const OwnerHomePage();
                    } else if (role == "user") {
                      return const UserHomePage();
                    } else {
                      return LoginScreen();
                    }

                    // Pass the username to HomePage
                    // return UserHomePage();
                  } else {
                    // print("Terjadi kesalahan");
                    // return Container(
                    //   child: Text("123"),
                    // );
                    // return Center(child: Text("User data not found"));
                    // return Center(child: CircularProgressIndicator());
                    return const AuthWrapper();
                  }
                } else {
                  // Show loading spinner while waiting for Firestore data
                  return Center(child: CircularProgressIndicator());
                }
              },
            );
          }
        } else {
          // Show loading spinner while waiting for auth state
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
