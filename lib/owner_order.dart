import 'package:flutter/material.dart';

class AddOrderPage extends StatefulWidget {
  const AddOrderPage({super.key});

  @override
  _AddOrderPageState createState() => _AddOrderPageState();
}

class _AddOrderPageState extends State<AddOrderPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _weightController = TextEditingController();

  String _service = 'Laundry';
  String _paymentStatus = 'Cash';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesanan Manual'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/bg1.png'), // Assuming bg1.png is in assets folder
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Form for order details
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama Pelanggan
                    const Text('Nama Pelanggan',
                        style: TextStyle(fontSize: 16, color: Colors.black)),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: 'Masukkan nama pelanggan',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama pelanggan harus diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Nomor Handphone
                    const Text('Nomor Handphone',
                        style: TextStyle(fontSize: 16, color: Colors.black)),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        hintText: 'Masukkan nomor handphone',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nomor handphone harus diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Alamat Tujuan
                    const Text('Alamat Tujuan',
                        style: TextStyle(fontSize: 16, color: Colors.black)),
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        hintText: 'Masukkan alamat tujuan',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Alamat tujuan harus diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Layanan
                    const Text('Layanan',
                        style: TextStyle(fontSize: 16, color: Colors.black)),
                    DropdownButtonFormField<String>(
                      value: _service,
                      onChanged: (String? newValue) {
                        setState(() {
                          _service = newValue!;
                        });
                      },
                      items: <String>['Laundry', 'Cuci Kering', 'Setrika']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Berat Pakaian (kg)
                    const Text('Berat Pakaian (kg)',
                        style: TextStyle(fontSize: 16, color: Colors.black)),
                    TextFormField(
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Masukkan berat pakaian',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Berat pakaian harus diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Status Pembayaran (with two options: Cash and QRIS)
                    const Text('Status Pembayaran',
                        style: TextStyle(fontSize: 16, color: Colors.black)),
                    Row(
                      children: [
                        // Cash Option
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _paymentStatus = 'Cash';
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: _paymentStatus == 'Cash'
                                    ? Colors.blue
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(
                                  color: _paymentStatus == 'Cash'
                                      ? Colors.blue
                                      : Colors.black,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Cash',
                                  style: TextStyle(
                                    color: _paymentStatus == 'Cash'
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // QRIS Option
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _paymentStatus = 'QRIS';
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: _paymentStatus == 'QRIS'
                                    ? Colors.blue
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: _paymentStatus == 'QRIS'
                                      ? Colors.blue
                                      : Colors.black,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'QRIS',
                                  style: TextStyle(
                                    color: _paymentStatus == 'QRIS'
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Button "Buat Pesanan"
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Pesanan Berhasil Dibuat')));
                            // Optionally, save the order to Firebase or a local database here
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, // Text color
                          backgroundColor: Colors.blue, // Button color
                          padding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 170.0), // Padding
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8.0), // Rounded corners
                          ),
                        ),
                        child: const Text('Buat Pesanan'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Pesanan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Keuangan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: 0, // Set the current index according to your logic
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          // Handle tap event if needed
        },
      ),
    );
  }
}
