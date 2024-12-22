import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class OwnerKeuanganPage extends StatelessWidget {
  final CollectionReference orders = FirebaseFirestore.instance
      .collection('orders'); // Ganti dengan nama koleksi Firestore Anda.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_wallet,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Text(
              'KEUANGAN',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications),
                onPressed: () {},
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '3',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: orders.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'Tidak ada data keuangan.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            );
          }

          final docs = snapshot.data!.docs;

          // Hitung total pemasukan berdasarkan price
          double totalIncome = 0;
          for (var doc in docs) {
            final totalPrice = doc['price'] as double? ?? 0.0;
            totalIncome += totalPrice;
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Kelola keuangan laundry Anda",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatCard('Total Pemasukan',
                          'Rp ${totalIncome.toStringAsFixed(0)}', Colors.green),
                      _buildStatCard('Total Pengeluaran', 'Rp 0',
                          Colors.red), // Placeholder untuk pengeluaran
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Grafik Keuangan",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildFinanceChart(docs),
                  const SizedBox(height: 20),
                  const Text(
                    "Daftar Transaksi",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap:
                        true, // Penting agar tidak error di dalam Column
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final order = docs[index];
                      final title = order['customer_name'] ?? 'Pesanan';
                      final date =
                          order['pickup_date'] ?? 'Tanggal tidak diketahui';
                      final totalPrice = order['price'] as double? ?? 0.0;

                      return _buildTransactionItem(
                        title,
                        date,
                        '+Rp ${totalPrice.toStringAsFixed(0)}',
                        true,
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          // Tambahkan aksi jika diperlukan
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatCard(String title, String amount, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              amount,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinanceChart(List<QueryDocumentSnapshot> docs) {
    // Mengelompokkan pemasukan berdasarkan bulan dari pickup_date
    Map<String, double> monthlyIncome = {};

    for (var doc in docs) {
      final totalPrice = doc['price'] as double? ?? 0.0;
      final date = doc['pickup_date'] ?? '';
      final month = date.split('-')[1]; // Asumsikan format "YYYY-MM-DD"

      if (monthlyIncome.containsKey(month)) {
        monthlyIncome[month] = monthlyIncome[month]! + totalPrice;
      } else {
        monthlyIncome[month] = totalPrice;
      }
    }

    // Membuat data untuk grafik
    List<BarChartGroupData> chartData = [];
    monthlyIncome.forEach((month, total) {
      chartData.add(BarChartGroupData(
        x: int.parse(month), // Menyusun berdasarkan bulan
        barRods: [
          BarChartRodData(
            toY: total, // Menggunakan toY, bukan y
            color: Colors.green, // Menggunakan warna hijau untuk pemasukan
            width: 15, // Mengatur lebar batang
            borderRadius: BorderRadius.circular(5), // Menambahkan border radius
          ),
        ],
      ));
    });

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          titlesData: FlTitlesData(show: true),
          borderData: FlBorderData(show: true),
          barGroups: chartData,
          gridData: FlGridData(show: true),
        ),
      ),
    );
  }

  Widget _buildTransactionItem(
      String title, String date, String amount, bool isIncome) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(
          isIncome ? Icons.arrow_downward : Icons.arrow_upward,
          color: isIncome ? Colors.green : Colors.red,
        ),
        title: Text(title),
        subtitle: Text(date),
        trailing: Text(
          amount,
          style: TextStyle(
            color: isIncome ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
