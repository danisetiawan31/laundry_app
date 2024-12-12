import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PickupDetailPage extends StatefulWidget {
  final String username;

  const PickupDetailPage({super.key, required this.username});

  @override
  State<PickupDetailPage> createState() => _PickupDetailPageState();
}

class _PickupDetailPageState extends State<PickupDetailPage> {
  int selectedPickupDateIndex = -1;
  int selectedDeliveryDateIndex = -1;
  String pickupTime = "";
  bool isLoading = false;

  final DateTime today = DateTime.now();
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

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  bool _isValidTimeFormat(String time) {
    final timeRegex = RegExp(r'^\d{1,2}:\d{2}$');
    return timeRegex.hasMatch(time);
  }

  void _confirmOrder() async {
    if (selectedPickupDateIndex == -1) {
      _showSnackbar("Please select a pickup date.");
      return;
    }
    if (pickupTime.isEmpty || !_isValidTimeFormat(pickupTime)) {
      _showSnackbar("Please enter a valid pickup time (e.g., 12:00).");
      return;
    }
    if (selectedDeliveryDateIndex == -1) {
      _showSnackbar("Please select a delivery date.");
      return;
    }

    final orderData = {
      'customer_name': widget.username,
      'pickup_date': decemberDates[selectedPickupDateIndex].toIso8601String(),
      'pickup_time': pickupTime,
      'delivery_date':
          decemberDates[selectedDeliveryDateIndex].toIso8601String(),
      'status': 'Belum Diproses',
    };

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseFirestore.instance.collection('orders').add(orderData);
      _showSnackbar("Order has been successfully created!");
      Navigator.pop(context, "Order Created");
    } catch (e) {
      _showSnackbar("Error: ${e.toString()}");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
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
        width: 60,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.blue,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              date.day.toString(),
              style: TextStyle(
                fontSize: 20,
                color: isSelected ? Colors.white : Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              dayName,
              style: TextStyle(
                fontSize: 14,
                color: isSelected ? Colors.white : Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
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
              'assets/bg1.png',
              fit: BoxFit.cover,
            ),
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          if (!isLoading)
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
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.blue),
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

                    // Nama Pelanggan dari Username
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue, width: 1.5),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.person, color: Colors.blue),
                          const SizedBox(width: 10),
                          Text(
                            "Pelanggan: ${widget.username}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Pickup Date
                    _buildScrollableSectionWithDropdown(
                      title: "Pickup Date",
                      selectedIndex: selectedPickupDateIndex,
                      itemCount: decemberDates.length,
                      itemBuilder: (index) {
                        final date = decemberDates[index];
                        final isAvailable =
                            date.isAfter(today) || date.isAtSameMomentAs(today);

                        return isAvailable
                            ? _buildDateBox(
                                date: date,
                                isSelected: selectedPickupDateIndex == index,
                                onTap: () {
                                  setState(() {
                                    selectedPickupDateIndex = index;
                                    selectedDeliveryDateIndex =
                                        -1; // Reset delivery date
                                  });
                                },
                              )
                            : const SizedBox(); // Hilangkan tanggal sebelum hari ini
                      },
                    ),

                    const SizedBox(height: 20),

                    // Pickup Time
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
                              setState(() {
                                pickupTime = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Delivery Date
                    _buildScrollableSectionWithDropdown(
                      title: "Delivery Date",
                      selectedIndex: selectedDeliveryDateIndex,
                      itemCount: decemberDates.length,
                      itemBuilder: (index) {
                        final date = decemberDates[index];
                        final isAvailable = selectedPickupDateIndex != -1 &&
                            date.isAfter(
                                decemberDates[selectedPickupDateIndex]);

                        return isAvailable
                            ? _buildDateBox(
                                date: date,
                                isSelected: selectedDeliveryDateIndex == index,
                                onTap: () {
                                  setState(() {
                                    selectedDeliveryDateIndex = index;
                                  });
                                },
                              )
                            : const SizedBox(); // Hilangkan tanggal sebelum pickup
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
                        onPressed: _confirmOrder,
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
}
