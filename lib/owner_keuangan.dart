import 'package:flutter/material.dart';

class OwnerKeuanganPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Keuangan'),
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
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Kelola keuangan laundry Anda",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard('Total Pemasukan', 'Rp 7.527.000', Colors.green),
                _buildStatCard('Total Pengeluaran', 'Rp 5.527.000', Colors.red),
              ],
            ),
            SizedBox(height: 20),
            Text(
              "Grafik Keuangan",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildFinanceChart(),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildTransactionItem(
                      "Pembayaran Pesanan", "20 Mar 2024", "+Rp 150.000", true),
                  _buildTransactionItem(
                      "Pembelian Deterjen", "19 Mar 2024", "-Rp 75.000", false),
                  _buildTransactionItem(
                      "Pembayaran Pesanan", "19 Mar 2024", "+Rp 90.000", true),
                  _buildTransactionItem(
                      "Biaya Listrik", "18 Mar 2024", "-Rp 450.000", false),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatCard(String title, String amount, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 8),
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

  Widget _buildFinanceChart() {
    // Placeholder for chart (Use a library like fl_chart for real data)
    return Container(
      height: 200,
      color: Colors.grey[200],
      child: Center(
        child: Text("Grafik Keuangan (Placeholder)"),
      ),
    );
  }

  Widget _buildTransactionItem(
      String title, String date, String amount, bool isIncome) {
    return ListTile(
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
    );
  }
}
