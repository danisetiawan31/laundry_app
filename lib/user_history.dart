import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  int selectedTab = 0;
  int _selectedIndex =
      1; // Updated index for History page in BottomNavigationBar

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Add navigation logic if necessary
    });
  }

  Widget _buildIcon(IconData icon, bool isSelected) {
    return Container(
      decoration: isSelected
          ? const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue, // Background color when selected
            )
          : null,
      padding: const EdgeInsets.all(8), // Padding around the icon
      child: Icon(
        icon,
        color: isSelected ? Colors.white : Colors.grey, // Icon color
        size: isSelected ? 28 : 24, // Icon size based on selection
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title:
              const Text('ORDER HISTORY', style: TextStyle(color: Colors.blue)),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: const Center(
          child: Text("User not logged in"),
        ),
      );
    }

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
              // Action for notifications
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Tabs for order status
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: const Text('Selesai'),
                  selected: selectedTab == 0,
                  selectedColor: Colors.lightBlue[100], // Hover color
                  onSelected: (bool selected) {
                    setState(() {
                      selectedTab = 0;
                    });
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Siap Diantar'),
                  selected: selectedTab == 1,
                  selectedColor: Colors.lightBlue[100], // Hover color
                  onSelected: (bool selected) {
                    setState(() {
                      selectedTab = 1;
                    });
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Belum Diproses'),
                  selected: selectedTab == 2,
                  selectedColor: Colors.lightBlue[100], // Hover color
                  onSelected: (bool selected) {
                    setState(() {
                      selectedTab = 2;
                    });
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Diproses'),
                  selected: selectedTab == 3,
                  selectedColor: Colors.lightBlue[100], // Hover color
                  onSelected: (bool selected) {
                    setState(() {
                      selectedTab = 3;
                    });
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Dibatalkan'),
                  selected: selectedTab == 4,
                  selectedColor: Colors.lightBlue[100], // Hover color
                  onSelected: (bool selected) {
                    setState(() {
                      selectedTab = 4;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('orders')
                  .where('customer_name', isEqualTo: user.displayName)
                  .where('status',
                      isEqualTo: selectedTab == 0
                          ? 'Selesai'
                          : selectedTab == 1
                              ? 'Siap Diantar'
                              : selectedTab == 2
                                  ? 'Belum Diproses'
                                  : selectedTab == 3
                                      ? 'Diproses'
                                      : 'Dibatalkan')
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
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(
                          "Order ID: ${order.id}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text("Address: ${order['address']}"),
                            Text("Delivery Date: ${order['delivery_date']}"),
                            Text("Price: Rp${order['price']}"),
                            Text(
                              "Status: ${order['status']}",
                              style: TextStyle(
                                color: order['status'] == 'Dibatalkan'
                                    ? Colors.red
                                    : Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: Colors.grey[600],
                        ),
                      ),
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
            icon: _buildIcon(Icons.history, _selectedIndex == 1),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.person, _selectedIndex == 2),
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
