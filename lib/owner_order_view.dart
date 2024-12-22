import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laundry_app/owner_order_detail.dart';
import 'owner_acc_order.dart';

class OwnerOrderView extends StatefulWidget {
  const OwnerOrderView({super.key});

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
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.local_laundry_service,
                color: Colors.white, size: 28),
            const SizedBox(width: 10),
            const Text(
              'Pesanan Pelanggan',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: Colors.white,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Accorder()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection:
                  Axis.horizontal, // Mengaktifkan scroll horizontal
              child: Row(
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
                  const SizedBox(width: 8),
                  FilterButton(
                    label: 'Diproses',
                    isActive: selectedFilter == 'Diproses',
                    onPressed: () {
                      setState(() {
                        selectedFilter = 'Diproses';
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  FilterButton(
                    label: 'Selesai',
                    isActive: selectedFilter == 'Selesai',
                    onPressed: () {
                      setState(() {
                        selectedFilter = 'Selesai';
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  FilterButton(
                    label: 'Siap Diantar',
                    isActive: selectedFilter == 'Siap Diantar',
                    onPressed: () {
                      setState(() {
                        selectedFilter = 'Siap Diantar';
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  FilterButton(
                    label: 'Dibatalkan',
                    isActive: selectedFilter == 'Dibatalkan',
                    onPressed: () {
                      setState(() {
                        selectedFilter = 'Dibatalkan';
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: selectedFilter == 'Semua'
                  ? orders.snapshots()
                  : orders
                      .where('status', isEqualTo: selectedFilter)
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
                      onDelete: () {
                        _showDeleteDialog(context, order.id);
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
                title: const Text('Siap Diantar'),
                onTap: () {
                  Navigator.of(context).pop('Siap Diantar');
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

  void _showDeleteDialog(BuildContext context, String orderId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Pesanan'),
          content: const Text('Apakah Anda yakin ingin menghapus pesanan ini?'),
          actions: [
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Hapus'),
              onPressed: () {
                Navigator.of(context).pop();
                deleteOrder(orderId);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteOrder(String orderId) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .delete();
      print('Pesanan berhasil dihapus.');
    } catch (e) {
      print('Gagal menghapus pesanan: $e');
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
  final VoidCallback onDelete;

  const OwnerOrderCard({
    super.key,
    required this.orderId,
    required this.customerName,
    required this.address,
    required this.date,
    required this.time,
    required this.status,
    required this.onStatusChange,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
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
              Text('#$orderId',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 8),
              Text(customerName,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
              Text(address, style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 4),
              Text('$date, $time',
                  style: const TextStyle(color: Colors.black54)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(status,
                      style: TextStyle(
                          color: _getStatusColor(status),
                          fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: onStatusChange,
                        icon: const Icon(Icons.edit, size: 18),
                        label: const Text('Ubah Status'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: onDelete,
                        icon: const Icon(Icons.delete, size: 18),
                        label: const Text('Hapus'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
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
      case 'Siap Diantar':
        return Colors.purple;
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
    super.key,
    required this.label,
    required this.isActive,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? Colors.blue : Colors.grey[300],
        foregroundColor: isActive ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 4, // Tambahkan shadow
      ),
      child: Row(
        children: [
          Icon(isActive ? Icons.check_circle : Icons.circle_outlined,
              size: 16, color: isActive ? Colors.white : Colors.grey),
          const SizedBox(width: 5),
          Text(label),
        ],
      ),
    );
  }
}
