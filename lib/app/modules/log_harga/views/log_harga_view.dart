import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/log_harga_controller.dart';

class LogHargaView extends GetView<LogHargaController> {
  const LogHargaView({Key? key}) : super(key: key);

  String formatCurrency(int? value) {
    if (value != null) {
      final currencyFormat = NumberFormat.currency(
        locale: 'id',
        symbol: 'Rp',
        decimalDigits: 0,
      ).format(value);
      return currencyFormat;
    }
    return '';
  }

  String formatDate(String? dateString) {
    if (dateString != null) {
      final date = DateTime.parse(dateString);
      final formattedDate =
          '${date.day}-${date.month.toString().padLeft(2, '0')}-${date.year}';
      return formattedDate;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Harga'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Widget untuk filter status cucian
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(() {
              return Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Layanan Cucian: ',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    DropdownButton<String>(
                      value: controller.selectedStatus.value,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          controller.filterByStatus(newValue);
                        }
                      },
                      items: controller.layananOptions.map((String option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                      hint: const Text('Filter Status Cucian'),
                    ),
                  ],
                ),
              );
            }),
          ),

          // Widget untuk filter tanggal diambil
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                DateTimeRange? picked = await showDateRangePicker(
                  currentDate: DateTime.now(),
                  context: context,
                  firstDate: DateTime(2023),
                  lastDate: DateTime(2100),
                  initialDateRange: DateTimeRange(
                    start: controller.selectedStartDate.value ?? DateTime.now(),
                    end: controller.selectedEndDate.value ?? DateTime.now(),
                  ),
                );
                if (picked != null) {
                  controller.filterByDate(picked);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                foregroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              child: const Text('Filter Tanggal'),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.isTrue) {
                return const Center(child: CircularProgressIndicator());
              } else if (controller.filteredData.isEmpty) {
                return const Center(child: Text('Tidak Ada Data Log Harga'));
              } else {
                return ListView.builder(
                  itemCount: controller.filteredData.length,
                  itemBuilder: (context, index) {
                    final userData = controller.filteredData[index];
                    return Card(
                      color: Colors.greenAccent,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(8.0),
                        title: Row(
                          children: [
                            Image.asset(
                              'images/hand-holding-usd.png',
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
                                    'Kategori: ${userData['id_harga']['kategori_pelanggan']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    'Metode: ${userData['id_harga']['metode_laundry_id']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    'Layanan: ${userData['id_harga']['layanan_laundry_id']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    'Harga/Kg (Lama): ${formatCurrency(userData['harga_kilo_lama'] is int ? userData['harga_kilo_lama'] as int : int.tryParse(userData['harga_kilo_lama'] ?? '') ?? 0)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    'Harga/Kg (Baruj): ${formatCurrency(userData['harga_kilo_baru'] is int ? userData['harga_kilo_baru'] as int : int.tryParse(userData['harga_kilo_baru'] ?? '') ?? 0)}',
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
                          // // Get.deleteAll();
                          // // Get.put(PaneltransaksiController());
                          // Get.toNamed(Routes.UPDATE_DATA_HARGA, arguments: userData);
                        },
                      ),
                    );
                  },
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}
