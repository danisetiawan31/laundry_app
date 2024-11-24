import 'package:flutter/material.dart';
import 'user_home_page.dart'; // Import halaman UserHomePage

class DeliveryOptionPage extends StatelessWidget {
  const DeliveryOptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background menyeluruh
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('bg1.png'), // Gambar latar belakang
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // AppBar Custom
                Container(
                  color: Colors.blue.withOpacity(0.8),
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const Text(
                        'PRICE LIST ORDER',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          // Tab Layanan
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: const [
                              DeliveryTab(title: "Cuci Aja", isSelected: true),
                              DeliveryTab(title: "Cuci Setrika"),
                              DeliveryTab(title: "Cuci Bed Cover"),
                              DeliveryTab(title: "Cuci Gorden"),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Pilihan Layanan
                          const DeliveryOptionCard(
                            title: "Anter Jemput",
                            price: "8.000 / KG",
                            imagePath: "logo3.png",
                          ),
                          const SizedBox(height: 10),
                          const DeliveryOptionCard(
                            title: "Jemput Sendiri",
                            price: "7.000 / KG",
                            imagePath: "logo2.png",
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 40.0),
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const UserHomePage(),
                                ),
                              );
                            },
                            child: const Text(
                              "KONFIRMASI",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DeliveryTab extends StatelessWidget {
  final String title;
  final bool isSelected;

  const DeliveryTab({super.key, required this.title, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Aksi saat tab dipilih
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(color: Colors.blue),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class DeliveryOptionCard extends StatelessWidget {
  final String title;
  final String price;
  final String imagePath;

  const DeliveryOptionCard({
    super.key,
    required this.title,
    required this.price,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white
            .withOpacity(0.9), // Transparansi agar background terlihat
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5.0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(
            imagePath,
            height: 50,
            width: 50,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.error, color: Colors.red);
            },
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(price),
            ],
          ),
        ],
      ),
    );
  }
}
