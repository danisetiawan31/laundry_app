import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Orderdetail.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({Key? key}) : super(key: key);

  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  String? selectedName;

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  Future<void> fetchUserName() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        setState(() {
          selectedName = userDoc['name'];
        });
      }
    } catch (e) {
      print('Error fetching user name: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Referensi koleksi orders dari Firestore
    final CollectionReference orders =
        FirebaseFirestore.instance.collection('orders');
    final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Pesanan ${selectedName ?? ''}'),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: orders.where('user_id', isEqualTo: currentUserId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada riwayat pesanan.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            );
          }

          final orderDocs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: orderDocs.length,
            itemBuilder: (context, index) {
              final order = orderDocs[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        _getStatusColor(order['status'] ?? 'Tidak diketahui'),
                    child: const Icon(Icons.receipt, color: Colors.white),
                  ),
                  title: Text(
                    'Pesanan #${order.id}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Tanggal: ${order['pickup_date'] ?? 'Tidak diketahui'}'),
                      Text('Status: ${order['status'] ?? 'Tidak diketahui'}'),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navigasi ke halaman detail pesanan
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetailView(
                          orderId: order.id,
                          customerName:
                              order['customer_name'] ?? 'Tidak tersedia',
                          address: order['address'] ?? 'Tidak tersedia',
                          date: order['pickup_date'] ?? 'Tidak diketahui',
                          time: order['pickup_time'] ?? 'Tidak diketahui',
                          status: order['status'] ?? 'Tidak diketahui',
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Diproses':
        return Colors.orange;
      case 'Selesai':
        return Colors.green;
      case 'Dibatalkan':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}
