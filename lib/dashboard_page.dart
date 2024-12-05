import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardPage extends StatelessWidget {
  final CollectionReference orders =
      FirebaseFirestore.instance.collection('orders');

  DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Owner'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main Features Section
              const Text(
                'Main Features',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // ... (Kode untuk fitur utama tetap sama)

              const Divider(height: 30),

              // Recent Orders Section
              const Text(
                'Orderan Sudah Dipesan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
                stream: orders
                    .where('status', isEqualTo: 'Sudah Dipesan')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final data = snapshot.requireData;

                  if (data.size == 0) {
                    return const Text('Tidak ada orderan yang sudah dipesan.');
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.size,
                    itemBuilder: (context, index) {
                      final order = data.docs[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: const Icon(Icons.local_laundry_service,
                              color: Colors.purple),
                          title: Text(
                              order['customer_name'] ?? 'Nama Tidak Diketahui'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Pickup: ${order['pickup_date'] ?? 'Tidak diketahui'}'),
                              Text(
                                  'Status: ${order['status'] ?? 'Belum Diproses'}'),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => deleteOrder(order.id),
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Detail Pesanan'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                        'Nama Pelanggan: ${order['customer_name']}'),
                                    Text(
                                        'Pickup Date: ${order['pickup_date']}'),
                                    Text('Status: ${order['status']}'),
                                  ],
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
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add New Order',
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
        onPressed: () {
          addOrder();
        },
      ),
    );
  }

  Future<void> addOrder() {
    return orders.add({
      'customer_name': 'Pelanggan Baru',
      'pickup_date': '2024-12-10',
      'status': 'Sudah Dipesan',
    });
  }

  Future<void> deleteOrder(String id) {
    return orders.doc(id).delete();
  }
}
