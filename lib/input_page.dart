import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InputPage extends StatelessWidget {
  final CollectionReference finance =
      FirebaseFirestore.instance.collection('finance'); // Koleksi Firestore

  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  InputPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Input Keuangan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Deskripsi'),
            ),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Jumlah (Rp)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                addFinanceData(
                    descriptionController.text, amountController.text);
                amountController.clear();
                descriptionController.clear();
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk menambahkan data keuangan ke Firestore
  Future<void> addFinanceData(String description, String amount) {
    return finance.add({
      'description': description,
      'amount': int.parse(amount),
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
