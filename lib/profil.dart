import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:laundry_app/login_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? currentUser;
  Map<String, dynamic>? userData;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController profileImageUrlController =
      TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  Future<void> getCurrentUser() async {
    try {
      currentUser = _auth.currentUser;
      if (currentUser != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(currentUser!.uid).get();

        if (userDoc.exists) {
          setState(() {
            userData = userDoc.data() as Map<String, dynamic>?;
            nameController.text = userData?['name'] ?? '';
            phoneController.text = userData?['phone'] ?? '';
            profileImageUrlController.text = userData?['profileImage'] ?? '';
            addressController.text = userData?['address'] ?? '';
          });
        } else {
          // Jika dokumen pengguna belum ada
          setState(() {
            userData = {};
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching profile: $e")),
      );
    }
  }

  Future<void> updateProfile() async {
    try {
      // Validasi URL gambar jika ada
      if (profileImageUrlController.text.trim().isNotEmpty &&
          !Uri.parse(profileImageUrlController.text.trim()).isAbsolute) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid image URL!")),
        );
        return;
      }

      // Update Firestore
      final updateData = <String, dynamic>{};
      if (nameController.text.trim().isNotEmpty) {
        updateData['name'] = nameController.text.trim();
      }
      if (phoneController.text.trim().isNotEmpty) {
        updateData['phone'] = phoneController.text.trim();
      }
      if (profileImageUrlController.text.trim().isNotEmpty) {
        updateData['profileImage'] = profileImageUrlController.text.trim();
      }
      if (addressController.text.trim().isNotEmpty) {
        updateData['address'] = addressController.text.trim();
      }

      await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .update(updateData);

      // Update data lokal
      setState(() {
        userData?['name'] = nameController.text.trim();
        userData?['phone'] = phoneController.text.trim();
        userData?['profileImage'] = profileImageUrlController.text.trim();
        userData?['address'] = addressController.text.trim();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating profile: $e")),
      );
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PROFILE', style: TextStyle(color: Colors.blue)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: logout,
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue),
            onPressed: () => _showEditDialog(),
          ),
        ],
      ),
      body: userData == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(30)),
                  ),
                  child: Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: userData?['profileImage'] != null
                          ? NetworkImage(userData!['profileImage'])
                          : null,
                      child: userData?['profileImage'] == null
                          ? const Icon(Icons.person,
                              size: 60, color: Colors.white)
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProfileItem(
                          icon: Icons.person,
                          label: userData?['name'] ?? 'Name not available',
                        ),
                        ProfileItem(
                          icon: Icons.phone,
                          label: userData?['phone'] ?? 'Phone not available',
                        ),
                        ProfileItem(
                          icon: Icons.email,
                          label: userData?['email'] ?? 'Email not available',
                        ),
                        ProfileItem(
                          icon: Icons.home,
                          label:
                              userData?['address'] ?? 'Address not available',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Profile"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: "Phone"),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: profileImageUrlController,
                decoration:
                    const InputDecoration(labelText: "Profile Image URL"),
                keyboardType: TextInputType.url,
              ),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: "Address"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await updateProfile();
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}

class ProfileItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const ProfileItem({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.black54),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
