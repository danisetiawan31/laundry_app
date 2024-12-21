import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  int selectedTab = 0;
  int _selectedIndex =
      3; // Indeks 3 untuk halaman History di BottomNavigationBar

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Tambahkan logika navigasi jika perlu, misalnya pindah ke halaman lain
      // Berdasarkan indeks yang diklik
    });
  }

  Widget _buildIcon(IconData icon, bool isSelected) {
    return Container(
      decoration: isSelected
          ? const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue, // Warna latar belakang saat terpilih
            )
          : null,
      padding: const EdgeInsets.all(8), // Jarak padding di sekitar ikon
      child: Icon(
        icon,
        color: isSelected ? Colors.white : Colors.grey, // Warna ikon
        size: isSelected ? 28 : 24, // Ukuran ikon sesuai pilihan
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('ORDER HISTORY', style: TextStyle(color: Colors.blue)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.blue),
            onPressed: () {
              // Aksi untuk notifikasi
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab untuk memilih status pesanan
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChoiceChip(
                label: const Text('Upcoming'),
                selected: selectedTab == 0,
                selectedColor:
                    Colors.lightBlue[100], // Warna hover yang diinginkan
                onSelected: (bool selected) {
                  setState(() {
                    selectedTab = 0;
                  });
                },
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('Completed'),
                selected: selectedTab == 1,
                selectedColor: Colors.grey[300], // Warna hover yang diinginkan
                onSelected: (bool selected) {
                  setState(() {
                    selectedTab = 1;
                  });
                },
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('Cancelled'),
                selected: selectedTab == 2,
                selectedColor: Colors.grey[300], // Warna hover yang diinginkan
                onSelected: (bool selected) {
                  setState(() {
                    selectedTab = 2;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('orders')
                  .where('status',
                      isEqualTo: selectedTab == 0
                          ? 'upcoming'
                          : selectedTab == 1
                              ? 'completed'
                              : 'cancelled')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final orders = snapshot.data!.docs;
                if (orders.isEmpty) {
                  return const Center(child: Text("There is no order"));
                }
                return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    var order = orders[index];
                    return ListTile(
                      title: Text("Order #${order['orderNumber']}"),
                      subtitle: Text(order['details']),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.home, _selectedIndex == 0),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.shopping_bag, _selectedIndex == 1),
            label: 'Ordger',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.chat, _selectedIndex == 2),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.history, _selectedIndex == 3),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.person, _selectedIndex == 4),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }
}