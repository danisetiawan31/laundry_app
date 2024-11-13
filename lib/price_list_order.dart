import 'package:flutter/material.dart';

class PriceListOrderPage extends StatefulWidget {
  const PriceListOrderPage({Key? key}) : super(key: key);

  @override
  _PriceListOrderPageState createState() => _PriceListOrderPageState();
}

class _PriceListOrderPageState extends State<PriceListOrderPage> {
  final Map<String, int> _items = {
    "Kaos": 0,
    "Kemeja": 0,
    "Celana Pendek": 0,
    "Celana Panjang (Jeans)": 0,
    "Jaket": 0
  };

  final Map<String, String> _weights = {
    "Kaos": "250 Gram / Pcs",
    "Kemeja": "300 Gram / Pcs",
    "Celana Pendek": "300 Gram / Pcs",
    "Celana Panjang (Jeans)": "800 Gram / Pcs",
    "Jaket": "1 Kg / Pcs"
  };

  void _increment(String item) {
    setState(() {
      _items[item] = _items[item]! + 1;
    });
  }

  void _decrement(String item) {
    setState(() {
      if (_items[item]! > 0) {
        _items[item] = _items[item]! - 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Price List Order"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Cuci Aja",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  String key = _items.keys.elementAt(index);
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: Icon(Icons.shopping_cart_outlined),
                      title: Text(key),
                      subtitle: Text(_weights[key]!),
                      trailing: SizedBox(
                        width: 120,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () => _decrement(key),
                            ),
                            Text(
                              _items[key].toString(),
                              style: const TextStyle(fontSize: 18),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => _increment(key),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Tambahkan logika untuk memproses pesanan
                  Navigator.pop(context); // Kembali ke halaman sebelumnya
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Pesan Sekarang",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
