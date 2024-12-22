import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'owner_notif.dart'; // Import NotificationsPage
import 'owner_order.dart'; // Import OwnerOrderView
import 'owner_order_view.dart'; // Import AddOrderPage
import 'owner_keuangan.dart';
import 'owner_profile.dart';

class OwnerHomePage extends StatefulWidget {
  const OwnerHomePage({super.key});

  @override
  _OwnerHomePageState createState() => _OwnerHomePageState();
}

class _OwnerHomePageState extends State<OwnerHomePage> {
  int _currentIndex = 0;
  double totalIncome = 0.0;
  Map<int, double> monthlyIncome = {};
  final Map<String, int> orderStatusCount = {
    'Siap Diambil': 0,
    'Diproses': 0,
    'Siap Diantar': 0,
    'Selesai': 0,
    'Dibatalkan': 0,
  };

  @override
  void initState() {
    super.initState();
    _fetchFinancialData();
    _fetchOrderStatusData();
  }

  Future<void> _fetchFinancialData() async {
    var snapshot = await FirebaseFirestore.instance.collection('orders').get();

    double income = 0.0;
    Map<int, double> monthlyData = {for (var i = 1; i <= 12; i++) i: 0.0};

    for (var doc in snapshot.docs) {
      final totalPrice = doc['price']?.toDouble() ?? 0.0;
      final date =
          doc['pickup_date'] as String? ?? ''; // Asumsikan format "YYYY-MM-DD"
      final month = date.isNotEmpty
          ? int.parse(date.split('-')[1])
          : 0; // Mendapatkan bulan

      if (month > 0) {
        if (monthlyData.containsKey(month)) {
          monthlyData[month] = monthlyData[month]! + totalPrice;
        } else {
          monthlyData[month] = totalPrice;
        }
      }

      income += totalPrice;
    }

    setState(() {
      totalIncome = income;
      monthlyIncome = monthlyData;
    });
  }

  Future<void> _fetchOrderStatusData() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('orders').get();
      final statusCounts = Map<String, int>.from(orderStatusCount);

      snapshot.docs.forEach((doc) {
        final status = doc['status'] as String?;
        if (status != null && statusCounts.containsKey(status)) {
          statusCounts[status] = statusCounts[status]! + 1;
        }
      });

      setState(() {
        orderStatusCount.addAll(statusCounts);
      });
    } catch (e) {
      debugPrint('Error fetching order status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex == 0
          ? AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.blue,
              title: Row(
                children: [
                  Icon(
                    Icons.home,
                    size: 30,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Dashboard',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Selamat datang di Shabrina Laundry',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NotificationsPage()),
                    );
                  },
                ),
              ],
            )
          : null, // AppBar hanya untuk halaman Dashboard
      body: _buildBody(),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddOrderPage()),
                );
              },
              backgroundColor: Colors.blue,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null, // FAB hanya untuk halaman Dashboard
      bottomNavigationBar: _buildBottomNavigationBar(),
      backgroundColor: const Color(0xFFF7F4FB),
    );
  }

  Widget _buildBody() {
    if (_currentIndex == 0) {
      return _buildDashboardPage(); // Dashboard Page
    } else if (_currentIndex == 1) {
      return const OwnerOrderView(); // Orders Page
    } else if (_currentIndex == 2) {
      return OwnerKeuanganPage(); // Keuangan Page
    } else {
      return ProfilePage(); // Profile Page
    }
  }

  Widget _buildDashboardPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 80.0), // Menghindari overflow
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _buildSummaryCard('Pemasukan',
                        'Rp ${totalIncome.toStringAsFixed(0)}', Colors.green),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildSummaryCard('Pengeluaran', 'Rp 0', Colors.red),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Grafik Keuangan",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildFinanceChart(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildOrderStatusCard(),
            ),
          ],
        ),
      ),
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

  Widget _buildFinanceChart() {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          barGroups: monthlyIncome.entries.map((entry) {
            return BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                  toY: entry.value,
                  color: Colors.green,
                  width: 16,
                ),
              ],
            );
          }).toList(),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  switch (value.toInt()) {
                    case 1:
                      return const Text('Jan');
                    case 2:
                      return const Text('Feb');
                    case 3:
                      return const Text('Mar');
                    case 4:
                      return const Text('Apr');
                    case 5:
                      return const Text('May');
                    case 6:
                      return const Text('Jun');
                    case 7:
                      return const Text('Jul');
                    case 8:
                      return const Text('Aug');
                    case 9:
                      return const Text('Sep');
                    case 10:
                      return const Text('Oct');
                    case 11:
                      return const Text('Nov');
                    case 12:
                      return const Text('Dec');
                    default:
                      return const Text('');
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderStatusCard() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Status Pesanan',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: orderStatusCount.entries.length,
            itemBuilder: (context, index) {
              final entry = orderStatusCount.entries.elementAt(index);
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          entry.key,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      Text(
                        entry.value.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
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
      },
    );
  }
}
