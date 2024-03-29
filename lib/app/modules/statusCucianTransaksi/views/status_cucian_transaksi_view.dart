import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/status_cucian_transaksi_controller.dart';

class StatusCucianTransaksiView extends GetView<StatusCucianTransaksiController> {
  const StatusCucianTransaksiView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Status Cucian '),
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
      body: Scrollbar(
        thumbVisibility: true,
        trackVisibility: true,
        interactive: true,
        scrollbarOrientation: ScrollbarOrientation.right,
        thickness: 7,
        radius: const Radius.circular(20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: TextField(
                onChanged: (value) {
                  // Trigger search based on the entered value
                  controller.searchByName(value);
                },
                decoration: InputDecoration(
                  labelText: 'Cari Data Berdasarkan Nama',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            Obx(() {
              if (controller.isLoading.value) {
                // Display a loading indicator while loading data
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Text('Jumlah Data: ${controller.filteredData.length.toString()}');
            }),
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
                        color: userData['status_cucian'] == 'Dalam Proses'
                            ? Colors.teal
                            : Colors.greenAccent,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(8.0),
                          title: Row(
                            children: [
                              Image.asset(
                                'images/history_icon.png', // Replace with the actual path
                                width:
                                    70, // Set the width of the image as per your requirement
                                height:
                                    70, // Set the height of the image as per your requirement
                              ),
                              const SizedBox(width: 10),
                              // Add some space between the image and text
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Id Transaksi: ${userData['id_transaksi']}',
                                      style: TextStyle(
                                        color: userData['is_active'] == true
                                            ? Colors.black
                                            : Colors.white,
                                        fontWeight: userData['is_active'] == true
                                            ? FontWeight.normal
                                            : FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Nama: ${userData['id_user']['nama']}',
                                      style: TextStyle(
                                        color: userData['is_active'] == true
                                            ? Colors.black
                                            : Colors.white,
                                        fontWeight: userData['is_active'] == true
                                            ? FontWeight.normal
                                            : FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Status Cucian: ${userData['status_cucian'].toString().capitalizeFirst}',
                                      style: TextStyle(
                                        color: userData['is_active'] == true
                                            ? Colors.black
                                            : Colors.white,
                                        fontWeight: userData['is_active'] == true
                                            ? FontWeight.normal
                                            : FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            // Get.toNamed(Routes.DETAILPELANGGAN, arguments: userData);
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
      ),
    );
  }
}
