import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/paneltransaksi_controller.dart';

class PaneltransaksiView extends GetView<PaneltransaksiController> {
  PaneltransaksiView({Key? key}) : super(key: key);
  // TODO UBAH DATA HARGA MENJADI FORMAT RP
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel Harga'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              controller.refreshData();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
            child: TextField(
              onChanged: (value) {
                // Trigger search based on the entered value
                controller.searchByName(value);
              },
              decoration: InputDecoration(
                labelText: 'Cari Data Berdasarkan Metode',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                // Display a loading indicator while loading data
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView.builder(
                itemCount: controller.filteredData.length,
                itemBuilder: (context, index) {
                  var userData = controller.filteredData[index];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: Card(
                      color: Colors.greenAccent,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(8.0),
                        title: Row(
                          children: [
                            Image.asset(
                              'images/settings.png',
                              width: 70,
                              height: 70,
                            ),
                            const SizedBox(width: 10),
                            // Add some space between the image and text
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Id Harga: ${userData['id']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    'Kategori: ${userData['kategori_pelanggan']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    'Metode: ${userData['metode_laundry_id']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    'Layanan: ${userData['layanan_laundry_id']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    'Harga/Kg: ${userData['harga_kilo']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    'Di Perbaharui Pada: ${formatDate(userData['edit_at'] as String)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          Get.toNamed(Routes.UPDATE_DATA_HARGA, arguments: userData);
                        },
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  String formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    final formattedDate = '${date.day}-${date.month}-${date.year}';
    return formattedDate;
  }
}
