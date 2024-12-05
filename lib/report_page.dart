import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportPage extends StatelessWidget {
  final CollectionReference finance =
      FirebaseFirestore.instance.collection('finance'); // Koleksi Firestore

  ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Bulanan'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: finance.orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.requireData;

          // Safely cast `num` to `int` using `toInt()`
          int total = data.docs.fold(0, (sum, doc) {
            final amount = doc['amount'];
            return sum + (amount is num ? amount.toInt() : 0);
          });

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Total Keuangan: Rp$total',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: data.size,
                  itemBuilder: (context, index) {
                    final entry = data.docs[index];
                    return Card(
                      child: ListTile(
                        title: Text(entry['description'] ?? 'Tidak Diketahui'),
                        subtitle: Text(
                          'Jumlah: Rp${entry['amount']}',
                        ),
                        trailing: Text(
                          (entry['timestamp'] as Timestamp)
                              .toDate()
                              .toString()
                              .split(' ')[0],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
