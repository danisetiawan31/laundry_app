import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PickupDetailPage extends StatefulWidget {
  const PickupDetailPage({Key? key}) : super(key: key);

  @override
  State<PickupDetailPage> createState() => _PickupDetailPageState();
}

class _PickupDetailPageState extends State<PickupDetailPage> {
  int selectedPickupDateIndex = -1;
  int selectedDeliveryDateIndex = -1;
  String customerName = "";
  String pickupTime = ""; // Variabel untuk menyimpan waktu penjemputan

  final List<DateTime> decemberDates = List.generate(
    31,
    (index) => DateTime(2024, 12, index + 1),
  );

  String _getDayName(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return "Mon";
      case DateTime.tuesday:
        return "Tue";
      case DateTime.wednesday:
        return "Wed";
      case DateTime.thursday:
        return "Thu";
      case DateTime.friday:
        return "Fri";
      case DateTime.saturday:
        return "Sat";
      case DateTime.sunday:
        return "Sun";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/bg1.png', // Pastikan file ini ada di folder assets Anda
              fit: BoxFit.cover,
            ),
          ),
          // Content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40), // Space untuk status bar
                  // AppBar
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.blue),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      const Text(
                        "DETAIL PENJEMPUTAN",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Nama Pelanggan
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Nama Pelanggan',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      customerName = value;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Alamat Penjemputan
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue, width: 1.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Jl. Depati Parbo, Telanaipura",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Tambahkan aksi untuk ubah alamat
                          },
                          child: Row(
                            children: const [
                              Icon(Icons.edit, color: Colors.blue, size: 18),
                              SizedBox(width: 4),
                              Text(
                                "Ubah Alamat Baru",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Pickup Date (Dengan Dropdown)
                  _buildScrollableSectionWithDropdown(
                    title: "Pickup Date",
                    selectedIndex: selectedPickupDateIndex,
                    itemCount: decemberDates.length,
                    itemBuilder: (index) {
                      final date = decemberDates[index];
                      return _buildDateBox(
                        date: date,
                        isSelected: selectedPickupDateIndex == index,
                        onTap: () {
                          setState(() {
                            selectedPickupDateIndex = index;
                          });
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Pickup Time (Diinput secara manual)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 243, 243, 243)
                          .withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Pickup Time",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'Input Pickup Time (e.g., 12:00)',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.datetime,
                          onChanged: (value) {
                            pickupTime = value;
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Delivery Date (Dengan Dropdown)
                  _buildScrollableSectionWithDropdown(
                    title: "Delivery Date",
                    selectedIndex: selectedDeliveryDateIndex,
                    itemCount: decemberDates.length,
                    itemBuilder: (index) {
                      final date = decemberDates[index];
                      return _buildDateBox(
                        date: date,
                        isSelected: selectedDeliveryDateIndex == index,
                        onTap: () {
                          setState(() {
                            selectedDeliveryDateIndex = index;
                          });
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 30),

                  // Confirm Button
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        if (selectedPickupDateIndex == -1 ||
                            pickupTime.isEmpty || // Validasi pickupTime
                            selectedDeliveryDateIndex == -1 ||
                            customerName.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Please complete all fields!")),
                          );
                          return;
                        }

                        final orderData = {
                          'customer_name': customerName,
                          'pickup_date': decemberDates[selectedPickupDateIndex]
                              .toIso8601String(),
                          'pickup_time': pickupTime, // Masukkan pickupTime
                          'delivery_date':
                              decemberDates[selectedDeliveryDateIndex]
                                  .toIso8601String(),
                          'status': 'Belum Diproses',
                        };

                        try {
                          await FirebaseFirestore.instance
                              .collection('orders')
                              .add(orderData);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "Order has been successfully created!")),
                          );
                          Navigator.pop(context);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Error: ${e.toString()}")),
                          );
                        }
                      },
                      child: const Text(
                        "KONFIRMASI",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScrollableSectionWithDropdown({
    required String title,
    required int selectedIndex,
    required int itemCount,
    required Widget Function(int) itemBuilder,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 243, 243, 243).withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              DropdownButton<String>(
                value: "December 2024",
                items: const [
                  DropdownMenuItem(
                    value: "December 2024",
                    child: Text("December 2024"),
                  ),
                ],
                onChanged: (value) {},
                underline: const SizedBox(),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: itemCount,
              itemBuilder: (context, index) => itemBuilder(index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateBox({
    required DateTime date,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final dayName = _getDayName(date.weekday);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue, width: 1.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              dayName,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.blue,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "${date.day}",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
