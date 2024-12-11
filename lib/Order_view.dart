import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laundry_app/Orderdetail.dart';
import 'AccOrder.dart';

class OwnerOrderView extends StatefulWidget {
  const OwnerOrderView({Key? key}) : super(key: key);

  @override
  _OwnerOrderViewState createState() => _OwnerOrderViewState();
}

class _OwnerOrderViewState extends State<OwnerOrderView> {
  final CollectionReference orders =
      FirebaseFirestore.instance.collection('orders');
  String selectedFilter = 'Semua'; // Filter yang aktif

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Pesanan Pelanggan'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Navigasi ke halaman Accorder
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const Accorder()), // Arahkan ke Accorder.dart
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Header dengan Filter Status
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FilterButton(
                  label: 'Semua',
                  isActive: selectedFilter == 'Semua',
                  onPressed: () {
                    setState(() {
                      selectedFilter = 'Semua';
                    });
                  },
                ),
                FilterButton(
                  label: 'Diproses',
                  isActive: selectedFilter == 'Diproses',
                  onPressed: () {
                    setState(() {
                      selectedFilter = 'Diproses';
                    });
                  },
                ),
                FilterButton(
                  label: 'Selesai',
                  isActive: selectedFilter == 'Selesai',
                  onPressed: () {
                    setState(() {
                      selectedFilter = 'Selesai';
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: orders
                  .where('status',
                      isEqualTo:
                          selectedFilter == 'Semua' ? null : selectedFilter)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'Tidak ada pesanan.',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  );
                }

                final orderDocs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: orderDocs.length,
                  itemBuilder: (context, index) {
                    final order = orderDocs[index];
                    return OwnerOrderCard(
                      orderId: order.id,
                      customerName:
                          order['customer_name'] ?? 'Nama tidak tersedia',
                      address: order['address'] ?? 'Alamat tidak tersedia',
                      date: order['pickup_date'] ?? 'Tanggal tidak diketahui',
                      time: order['pickup_time'] ?? 'Waktu tidak diketahui',
                      status: order['status'] ?? 'Status tidak diketahui',
                      onStatusChange: () {
                        _showStatusDialog(context, order.id, order['status']);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk menampilkan dialog perubahan status
  Future<void> _showStatusDialog(
      BuildContext context, String orderId, String currentStatus) async {
    final newStatus = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ubah Status Pesanan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Diproses'),
                onTap: () {
                  Navigator.of(context).pop('Diproses');
                },
              ),
              ListTile(
                title: const Text('Selesai'),
                onTap: () {
                  Navigator.of(context).pop('Selesai');
                },
              ),
              ListTile(
                title: const Text('Dibatalkan'),
                onTap: () {
                  Navigator.of(context).pop('Dibatalkan');
                },
              ),
            ],
          ),
        );
      },
    );

    if (newStatus != null && newStatus != currentStatus) {
      await updateOrderStatus(orderId, newStatus);
    }
  }

  // Fungsi untuk memperbarui status di Firestore
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .update({'status': newStatus});
      print('Status berhasil diperbarui.');
    } catch (e) {
      print('Gagal memperbarui status: $e');
    }
  }
}

class OwnerOrderCard extends StatelessWidget {
  final String orderId;
  final String customerName;
  final String address;
  final String date;
  final String time;
  final String status;
  final VoidCallback onStatusChange;

  const OwnerOrderCard({
    Key? key,
    required this.orderId,
    required this.customerName,
    required this.address,
    required this.date,
    required this.time,
    required this.status,
    required this.onStatusChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigasi ke halaman detail pesanan
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetailView(
              orderId: orderId,
              customerName: customerName,
              address: address,
              date: date,
              time: time,
              status: status,
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ID Pesanan
              Text(
                '#$orderId',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              // Nama Pelanggan
              Text(
                customerName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              // Alamat
              Text(
                address,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 4),
              // Tanggal dan Waktu
              Text(
                '$date, $time',
                style: const TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Status Pesanan
                  Text(
                    status,
                    style: TextStyle(
                      color: _getStatusColor(status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Tombol Ubah Status
                  ElevatedButton(
                    onPressed: onStatusChange,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Ubah Status'),
                  ),
                ],
              ),
            ],
          ),
        ),
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

class FilterButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onPressed;

  const FilterButton({
    Key? key,
    required this.label,
    required this.isActive,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? Colors.blue : Colors.grey[300],
        foregroundColor: isActive ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(label),
    );
  }
}
