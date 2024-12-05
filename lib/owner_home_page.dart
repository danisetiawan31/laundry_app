import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OwnerOrderPage extends StatelessWidget {
  final CollectionReference orders =
      FirebaseFirestore.instance.collection('orders');

  OwnerOrderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Owner Dashboard'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: orders.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No orders found.'));
          }

          final orderDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orderDocs.length,
            itemBuilder: (context, index) {
              final order = orderDocs[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: const Icon(Icons.local_laundry_service,
                      color: Colors.blue),
                  title: Text(order['customer_name'] ?? 'Unknown Customer'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pickup Date: ${order['pickup_date'] ?? 'N/A'}'),
                      Text('Pickup Time: ${order['pickup_time'] ?? 'N/A'}'),
                      Text('Status: ${order['status'] ?? 'Unknown'}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteOrder(order.id),
                  ),
                  onTap: () {
                    _showOrderDetails(context, order);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _deleteOrder(String orderId) async {
    try {
      await orders.doc(orderId).delete();
    } catch (e) {
      print('Error deleting order: $e');
    }
  }

  void _showOrderDetails(BuildContext context, QueryDocumentSnapshot order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Order Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Customer Name: ${order['customer_name']}'),
            Text('Pickup Date: ${order['pickup_date']}'),
            Text('Pickup Time: ${order['pickup_time']}'),
            Text('Delivery Date: ${order['delivery_date']}'),
            Text('Status: ${order['status']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
