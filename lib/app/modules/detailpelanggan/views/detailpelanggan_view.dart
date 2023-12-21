import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controllers.dart';
import '../controllers/detailpelanggan_controller.dart';

class DetailpelangganView extends GetView<DetailpelangganController> {
  DetailpelangganView({Key? key}) : super(key: key);
  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    // Dapatkan data dari halaman sebelumnya
    final Map<String, dynamic> userData = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pelanggan'),
        centerTitle: true,
      ),
        body: FutureBuilder(
        future: controller.getdatapelanggan(userData), // Teruskan userData
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

          // Check if the data is not null before casting
          if (snapshot.data != null && snapshot.data is Map<String, dynamic>) {
            Map<String, dynamic> user = snapshot.data as Map<String, dynamic>;

            return ListView(padding: const EdgeInsets.all(10), children: [
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'images/user_profile.png',
                      width: 250,
                      height: 250,

                    ),

                    Text(
                      user['nama'].toString(), // Use the data from the fetched user
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      user['email'].toString(),
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      user['alamat'].toString(),
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '+62${user['phone']}'.toString(),
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      user['kategori'].toString(),
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      user['role'].toString(),
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
