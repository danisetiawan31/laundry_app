import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class addKeuanganOwner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return buildAddTransactionDialog(context);
  }

  Widget buildAddTransactionDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController amountController = TextEditingController();
    final TextEditingController notesController = TextEditingController();
    bool isIncome = true; // Default pemasukan

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: const EdgeInsets.all(16),
          content: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Tambah Transaksi",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () {
                        Navigator.of(context).pop(); // Tutup dialog
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isIncome ? Colors.grey[200] : Colors.redAccent,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          isIncome = false;
                        });
                      },
                      child: const Text("Pengeluaran"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isIncome ? Colors.green : Colors.grey[200],
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          isIncome = true;
                        });
                      },
                      child: const Text("Pemasukan"),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: "Judul Transaksi",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Nominal (Rp)",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: notesController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Catatan (Opsional)",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  // Validasi input
                  if (titleController.text.isEmpty ||
                      amountController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Semua field harus diisi!")),
                    );
                    return;
                  }

                  // Buat data transaksi baru
                  final newTransaction = {
                    'title': titleController.text,
                    'amount': double.tryParse(amountController.text) ?? 0.0,
                    'notes': notesController.text,
                    'type': isIncome ? 'income' : 'expense',
                    'date': DateTime.now().toIso8601String(),
                  };

                  // Simpan ke Firestore
                  FirebaseFirestore.instance
                      .collection('orders')
                      .add(newTransaction)
                      .then((_) {
                    Navigator.of(context)
                        .pop(); // Tutup dialog setelah menyimpan
                  });
                },
                child: const Text("Simpan"),
              ),
            ),
          ],
        );
      },
    );
  }
}
