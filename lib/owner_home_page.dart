import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'owner_notif.dart'; // Import NotificationsPage
import 'owner_order.dart'; // Import OwnerOrderView
import 'owner_order_view.dart'; // Import AddOrderPage
import 'owner_profile.dart';

class OwnerHomePage extends StatefulWidget {
  const OwnerHomePage({super.key});

  @override
  _OwnerHomePageState createState() => _OwnerHomePageState();
}

class _OwnerHomePageState extends State<OwnerHomePage> {
  int _currentIndex = 0;
  Map<String, int> orderStatusCount = {
    'Siap Diambil': 0,
    'Diproses': 0,
    'Siap Diantar': 0,
    'Selesai': 0,
    'Cancelled': 0,
  };

  @override
  void initState() {
    super.initState();
    _fetchOrderStatusData();
  }

  // Mengambil data pesanan dari Firestore dan menghitung jumlah per status
  _fetchOrderStatusData() async {
    var snapshot = await FirebaseFirestore.instance.collection('orders').get();

    var orderStatus = {
      'Siap Diambil': 0,
      'Diproses': 0,
      'Siap Diantar': 0,
      'Selesai': 0,
      'Cancelled': 0,
    };

    for (var doc in snapshot.docs) {
      String status = doc['status'];
      if (orderStatus.containsKey(status)) {
        orderStatus[status] = orderStatus[status]! + 1;
      }
    }

    setState(() {
      orderStatusCount = orderStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Selamat Datang,', style: TextStyle(fontSize: 16)),
            Text('Shabrina Laundry',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
          ],
        ),
        actions: [
          // Menambahkan tombol lonceng notifikasi di kanan atas
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Aksi untuk menampilkan notifikasi, bisa diarahkan ke halaman notifikasi
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NotificationsPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _buildSummaryCard('Pemasukan', 'Rp 0', Colors.green),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildSummaryCard('Pengeluaran', 'Rp 0', Colors.red),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('dashboardData')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data?.docs == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                var data =
                    snapshot.data!.docs.isEmpty ? null : snapshot.data!.docs[0];

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      data == null || data['financeStats'].isEmpty
                          ? _buildEmptyFinanceChart()
                          : _buildFinanceChart(data['financeStats'] ?? {}),
                      const SizedBox(height: 20),
                      _buildOrderStatusCard(),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigasi ke halaman OwnerOrder
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddOrderPage()),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Pesanan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Keuangan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          if (index == 1) {
            // Pastikan navigasi ke halaman pesanan
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const OwnerOrderView()),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          }
        },
      ),
      backgroundColor: const Color(0xFFF7F4FB),
    );
  }

  Widget _buildSummaryCard(String title, String amount, Color color) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: color, fontSize: 14)),
            const SizedBox(height: 4),
            Text(
              amount,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyFinanceChart() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statistik Keuangan',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 10),
          Center(
            child: Text(
              'Data tidak tersedia',
              style: TextStyle(color: Colors.grey, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinanceChart(Map<String, dynamic> stats) {
    return SizedBox(
      height: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Text(
              'Statistik Keuangan',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(
            child: BarChart(
              BarChartData(
                barGroups: stats.entries.map((entry) {
                  return BarChartGroupData(
                    x: int.parse(entry.key),
                    barRods: [
                      BarChartRodData(
                          toY: entry.value['income'].toDouble(),
                          color: Colors.blue),
                      BarChartRodData(
                          toY: entry.value['expense'].toDouble(),
                          color: Colors.red),
                    ],
                  );
                }).toList(),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        switch (value.toInt()) {
                          case 0:
                            return const Text('Sen');
                          case 1:
                            return const Text('Sel');
                          case 2:
                            return const Text('Rab');
                          case 3:
                            return const Text('Kam');
                          case 4:
                            return const Text('Jum');
                          case 5:
                            return const Text('Sab');
                          case 6:
                            return const Text('Min');
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderStatusCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Status Pesanan',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 10),
          _buildStatusRow(
              'Siap Diambil', orderStatusCount['Siap Diambil'].toString()),
          _buildStatusRow('Diproses', orderStatusCount['Diproses'].toString()),
          _buildStatusRow(
              'Siap Diantar', orderStatusCount['Siap Diantar'].toString()),
          _buildStatusRow('Selesai', orderStatusCount['Selesai'].toString()),
          _buildStatusRow(
              'Cancelled', orderStatusCount['Cancelled'].toString()),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String title, String count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 14)),
          Text(count,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
