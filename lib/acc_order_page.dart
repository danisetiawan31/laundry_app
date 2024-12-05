import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccOrderPage extends StatelessWidget {
  final CollectionReference orders =
      FirebaseFirestore.instance.collection('orders'); // Referensi ke Firestore

  AccOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ACC Orderan'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: orders.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.requireData;

          return ListView.builder(
            itemCount: data.size,
            itemBuilder: (context, index) {
              final order = data.docs[index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.local_laundry_service),
                  title: Text(order['customer_name'] ?? 'Tidak Diketahui'),
                  subtitle:
                      Text('Status: ${order['status'] ?? 'Belum Diproses'}'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      approveOrder(order.id); // Set status ke "Disetujui"
                    },
                    child: const Text('ACC'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Fungsi untuk memperbarui status order
  Future<void> approveOrder(String id) {
    return orders.doc(id).update({'status': 'Disetujui'});
  }
}
