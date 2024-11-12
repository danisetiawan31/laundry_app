import 'package:flutter/material.dart';

void main() => runApp(LaundryApp());

class LaundryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LaundryHomePage(),
    );
  }
}

class LaundryHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Price List Order"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Gambar Header
          Stack(
            children: [
              Image.asset(
                'assets/laundry.jpg', // Ganti dengan gambar kamu
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 10,
                left: 10,
                child: Text(
                  'PRICE LIST ORDER',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          // Tab Kategori
          Container(
            color: Colors.blue[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TabItem(title: 'Cuci Aja', isSelected: true),
                TabItem(title: 'Cuci Setrika'),
                TabItem(title: 'Cuci Bed Cover'),
                TabItem(title: 'Cuci Only'),
              ],
            ),
          ),
          // List Item
          Expanded(
            child: ListView(
              children: [
                LaundryItem(
                  title: "Kaos",
                  weight: "250 Gram / Pcs",
                  quantity: 10,
                ),
                LaundryItem(
                  title: "Kemeja",
                  weight: "300 Gram / Pcs",
                  quantity: 5,
                ),
                LaundryItem(
                  title: "Celana Pendek",
                  weight: "300 Gram / Pcs",
                  quantity: 0,
                ),
                LaundryItem(
                  title: "Celana Panjang (Jeans)",
                  weight: "800 Gram / Pcs",
                  quantity: 1,
                ),
                LaundryItem(
                  title: "Jaket",
                  weight: "500 Gram / Pcs",
                  quantity: 0,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class TabItem extends StatelessWidget {
  final String title;
  final bool isSelected;

  const TabItem({required this.title, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.blue : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

class LaundryItem extends StatelessWidget {
  final String title;
  final String weight;
  final int quantity;

  const LaundryItem({
    required this.title,
    required this.weight,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Card(
        elevation: 2,
        child: ListTile(
          leading: Icon(Icons.local_laundry_service, color: Colors.blue),
          title: Text(title),
          subtitle: Text(weight),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.remove_circle, color: Colors.red),
              ),
              Text(
                '$quantity',
                style: TextStyle(fontSize: 16),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.add_circle, color: Colors.green),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
