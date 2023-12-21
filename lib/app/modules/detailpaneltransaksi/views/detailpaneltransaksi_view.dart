import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../controllers/auth_controllers.dart';
import '../controllers/detailpaneltransaksi_controller.dart';

class DetailpaneltransaksiView extends GetView<DetailpaneltransaksiController> {
  DetailpaneltransaksiView({Key? key}) : super(key: key);
  final authC = Get.find<AuthController>();

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
        future: controller.getDataPanelTransaksi(dataPanel), // Teruskan dataData
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(child: Text('Error or no data: ${snapshot.error}'));
          }

          // Check if the data is not null before casting
          if (snapshot.data != null && snapshot.data is Map<String, dynamic>) {
            Map<String, dynamic> data = snapshot.data as Map<String, dynamic>;

            return ListView(padding: const EdgeInsets.all(10), children: [
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'images/data_profile.png',
                      width: 250,
                      height: 250,

                    ),

                    Text(
                      data['id'].toString(), // Use the data from the fetched data
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      data['email'].toString(),
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      data['alamat'].toString(),
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '+62${data['phone']}'.toString(),
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      data['kategori'].toString(),
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      data['role'].toString(),
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ]);
          } else {
            // Handle the case where the data is null or not of the expected type
            return Center(
              child: Text('Invalid data received'),
            );
          }
        },
      ),
    );
  }
}
