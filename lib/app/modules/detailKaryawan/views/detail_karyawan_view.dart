import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/detail_karyawan_controller.dart';

class DetailKaryawanView extends GetView<DetailKaryawanController> {
  DetailKaryawanView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dapatkan data dari halaman sebelumnya
    final Map<String, dynamic> userData = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pengguna'),
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
            if (kDebugMode) {
              print('Error: ${snapshot.error}');
            }
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          // Check if the data is not null before casting
          if (snapshot.data != null && snapshot.data is Map<String, dynamic>) {
            Map<String, dynamic> user = snapshot.data as Map<String, dynamic>;

            return Container(
              height: 800,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListView(
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(5),
                children: [
                  Image.asset(
                    'images/user_profile.png',
                    width: 250,
                    height: 250,
                  ),
                  const SizedBox(height: 5),
                  TextRow(label: 'ID Pengguna', value: user['id']?.toString() ?? '-'),
                  TextRow(label: 'Role Pengguna', value: user['role']?.toString() ?? '-'),
                  const SizedBox(height: 5),
                  TextRow(label: 'Nama Pengguna', value: user['nama']?.toString() ?? '-'),
                  const SizedBox(height: 5),
                  TextRow(label: 'Email Pengguna', value: user['email']?.toString() ?? '-'),
                  const SizedBox(height: 5),
                  TextRow(label: 'Nomor Pengguna', value: '+62${user['phone']}' ?? '-'),
                  const SizedBox(height: 5),
                  TextRow(
                    label: 'Kategori Pengguna',
                    value: user['kategori']?.toString() ?? '-',
                  ),
                  const SizedBox(height: 5),
                  TextRow(
                    label: 'Alamat Pengguna',
                    value: user['alamat']?.toString() ?? '-',
                  ),
                  const SizedBox(height: 5),
                  TextRow(
                    label: 'Status Pengguna',
                    value: (user['is_active'] == true) ? 'Aktif' : 'Tidak Aktif',
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: () {
                      if (user != null) {
                        Get.offAndToNamed(Routes.UPDATE_DATA_KARYAWAN, arguments: user);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.lightBlue,
                      minimumSize: const Size(150, 48),
                    ),
                    child: const Text(
                      'Update Data',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text('Data Error!'),
            );
          }
        },
      ),
    );
  }
}

class TextRow extends StatelessWidget {
  final String label;
  final String value;

  const TextRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(value),
      ],
    );
  }
}
