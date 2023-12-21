import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controllers.dart';
import '../controllers/detailpaneltransaksi_controller.dart';

class DetailpaneltransaksiView extends GetView<DetailpaneltransaksiController> {
  DetailpaneltransaksiView({Key? key}) : super(key: key);
  final authC = Get.find<AuthController>();

  final TextEditingController _harga = TextEditingController();
  final TextEditingController _expressPriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Dapatkan data dari halaman sebelumnya
    final Map<String, dynamic> dataPanel = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Panel Transaksi'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: controller.getDataPanelTransaksi(dataPanel),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error.toString()}'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          }

          if (snapshot.data is! Map<String, dynamic>) {
            return const Center(child: Text('Invalid data format'));
          }

          final Map<String, dynamic> data = snapshot.data as Map<String, dynamic>;

          _harga.text = data['harga_kilo']?.toString() ?? '';

          return ListView(
            padding: const EdgeInsets.all(10),
            children: [
              const SizedBox(height: 10),
              Center(
                child: Column(
                  children: [
                    Text(
                      data['kategori_pelanggan'].toString(),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      data['metode_laundry_id'].toString(),
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      data['layanan_laundry_id'].toString(),
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    // Text fields for editing prices
                    TextFormField(
                      controller: _harga,
                      decoration: const InputDecoration(labelText: 'Regular Price'),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => controller.updatePrices(
                        data['id'],
                        _harga.text.toString(),
                      ),
                      child: const Text('Update Prices'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
