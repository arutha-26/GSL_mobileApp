import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/pelanggan_transaksi_controller.dart';

class PelangganTransaksiView extends GetView<PelangganTransaksiController> {
  const PelangganTransaksiView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Data Transaksi'),
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
        body: Column(children: [
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
                      'Status Cucian: ',
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
                      items: controller.statusOptions.map((String option) {
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
                  lastDate: DateTime(2030),
                  initialDateRange: DateTimeRange(
                    start: DateTime.now(),
                    end: DateTime.now(),
                  ),
                );
                if (picked != null) {
                  controller.filterByDate(picked);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                foregroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(horizontal: 55), // Sesuaikan lebar tombol
              ),
              child: const Text('Pilih Tanggal Transaksi'),
            ),
          ),

          // Text(
          //   'Jumlah Data: ${controller.transactionHistory.length}',
          //   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          // ),
          // Widget untuk menampilkan data transaksi
          Expanded(
            child: Obx(() {
              if (controller.isLoading.isTrue) {
                return const Center(child: CircularProgressIndicator());
              } else if (controller.transactionHistory.isEmpty) {
                return const Center(child: Text('Tidak Ada Data Transaksi'));
              } else {
                return ListView.builder(
                  itemCount: controller.transactionHistory.length,
                  itemBuilder: (context, index) {
                    final transaction = controller.transactionHistory[index];
                    final isHidden = transaction['is_hidden'];

                    // Mengubah nilai status_pembayaran
                    final statusPembayaran =
                        transaction['status_pembayaran'] == 'sudah_dibayar'
                            ? 'Lunas'
                            : 'Belum Lunas';
                    // Determine card color based on IS_HIDDEN
                    final cardColor = isHidden ? Colors.green[600] : Colors.red[400];

                    return Card(
                      color: cardColor,
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap: () {
                          // Handle tap
                          // Get.toNamed(
                          //   Routes.DETAIL_HISTORY_PELANGGAN,
                          //   arguments: {'transaksi_id': transaction['transaksi_id']},
                          // );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                'images/history_icon.png',
                                width: 70,
                                height: 150,
                              ),
                              const SizedBox(width: 15), // Add spacing between image and text
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Tanggal Diambil: ${transaction['tanggal_diambil'] != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(transaction['tanggal_diambil'])) : '-'}',
                                          style: TextStyle(
                                            color: cardColor == Colors.green
                                                ? Colors.black
                                                : Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'ID Transaksi: ${transaction['id_transaksi']}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: cardColor == Colors.green
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'Status Cucian: ${transaction['status_cucian'].toString().capitalizeFirst}',
                                      style: TextStyle(
                                          color: cardColor == Colors.green
                                              ? Colors.black
                                              : Colors.white),
                                    ),
                                    Text(
                                      'Total Berat Laundry: ${transaction['berat_laundry']} kg',
                                      style: TextStyle(
                                        color: cardColor == Colors.green
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'Total Biaya: Rp${NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0).format(transaction['total_biaya'] as int)}',
                                      style: TextStyle(
                                        color: cardColor == Colors.green
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'Metode Pembayaran: ${transaction['metode_pembayaran']}',
                                      style: TextStyle(
                                        color: cardColor == Colors.green
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'Status Pembayaran: $statusPembayaran',
                                      style: TextStyle(
                                        color: cardColor == Colors.green
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            }),
          ),
        ]));
  }
}
