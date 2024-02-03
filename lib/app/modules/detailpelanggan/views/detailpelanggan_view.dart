import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../datapelanggan/views/datapelanggan_view.dart';
import '../controllers/detailpelanggan_controller.dart';

class DetailpelangganView extends GetView<DetailpelangganController> {
  DetailpelangganView({Key? key}) : super(key: key);

  final ScrollController _scrollController = ScrollController();

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
              height: 750,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Scrollbar(
                controller: _scrollController,
                thickness: 5,
                scrollbarOrientation: ScrollbarOrientation.right,
                radius: const Radius.circular(12),
                trackVisibility: true,
                thumbVisibility: true,
                interactive: true,
                child: ListView(
                  shrinkWrap: true,
                  controller: _scrollController,
                  // physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(5),
                  children: [
                    CustomImageWidget(
                      imageUrl: userData['avatar_url'],
                      width: 300,
                      height: 350,
                    ),
                    const SizedBox(height: 5),
                    // TextRow(label: 'ID User', value: user['id_user']?.toString() ?? '-'),
                    const SizedBox(height: 5),
                    TextRow(label: 'Nama Pelanggan', value: user['nama']?.toString() ?? '-'),
                    const SizedBox(height: 5),
                    TextRow(label: 'Email Pelanggan', value: user['email']?.toString() ?? '-'),
                    const SizedBox(height: 5),
                    TextRow(label: 'Nomor Pelanggan', value: '${user['no_telp']}' ?? '-'),
                    const SizedBox(height: 5),
                    TextRow(
                      label: 'Kategori Pelanggan',
                      value: user['kategori']?.toString() ?? '-',
                    ),
                    const SizedBox(height: 5),
                    TextRow(
                      label: 'Alamat Pelanggan',
                      value: user['alamat']?.toString() ?? '-',
                    ),
                    const SizedBox(height: 5),
                    TextRow(
                      label: 'Status Pelanggan',
                      value: user['is_active'] == true ? 'Aktif' : 'Tidak Aktif',
                    ),
                    const SizedBox(height: 25),
                    ElevatedButton(
                      onPressed: () {
                        if (user != null) {
                          Get.offAndToNamed(Routes.UPDATE_DATA_PELANGGAN, arguments: user);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent,
                        minimumSize: const Size(150, 48),
                      ),
                      child: const Text(
                        'Update Data',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
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
