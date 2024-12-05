import 'package:flutter/material.dart';

class PickupDetailPage extends StatefulWidget {
  const PickupDetailPage({Key? key}) : super(key: key);

  @override
  State<PickupDetailPage> createState() => _PickupDetailPageState();
}

class _PickupDetailPageState extends State<PickupDetailPage> {
  int selectedPickupDateIndex = -1;
  int selectedPickupTimeIndex = -1;
  int selectedDeliveryDateIndex = -1;

  final List<DateTime> decemberDates = List.generate(
    31,
    (index) => DateTime(2024, 12, index + 1),
  );

  final List<String> pickupTimes = ["12.00", "13.00", "14.00", "15.00"];

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

                  // Pickup Time (Tanpa Dropdown)
                  _buildScrollableSectionWithoutDropdown(
                    title: "Pickup Time",
                    selectedIndex: selectedPickupTimeIndex,
                    itemCount: pickupTimes.length,
                    itemBuilder: (index) {
                      final time = pickupTimes[index];
                      return _buildTimeBox(
                        time: time,
                        isSelected: selectedPickupTimeIndex == index,
                        onTap: () {
                          setState(() {
                            selectedPickupTimeIndex = index;
                          });
                        },
                      );
                    },
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
                      onPressed: () {
                        // Tambahkan aksi untuk konfirmasi
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

  // Bagian dengan dropdown (Pickup Date dan Delivery Date)
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
          // Header dengan dropdown
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
                onChanged: (value) {
                  // Tidak ada aksi, hanya dropdown statis
                },
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

  // Bagian tanpa dropdown (Pickup Time)
  Widget _buildScrollableSectionWithoutDropdown({
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
          // Header tanpa dropdown
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
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              dayName,
              style: TextStyle(
                fontSize: 14,
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "${date.day}",
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeBox({
    required String time,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            time,
            style: TextStyle(
              fontSize: 16,
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

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
}
