import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/pelanggan_paid_controller.dart';

class PelangganPaidView extends GetView<PelangganPaidController> {
  const PelangganPaidView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Transaksi Sukses'),
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
                                const SizedBox(
                                    width: 15), // Add spacing between image and text
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Tanggal Diambil: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(transaction['tanggal_diambil']))}',
                                            style: TextStyle(
                                                color: cardColor == Colors.green[600]
                                                    ? Colors.black
                                                    : Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'ID Transaksi: ${transaction['transaksi_id']}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: cardColor == Colors.green[600]
                                              ? Colors.black
                                              : Colors.white,
                                        ),
                                      ),
                                      Text(
                                        'Total Berat Laundry: ${transaction['berat_laundry']} kg',
                                        style: TextStyle(
                                          color: cardColor == Colors.green[600]
                                              ? Colors.black
                                              : Colors.white,
                                        ),
                                      ),
                                      Text(
                                        'Total Biaya: Rp. ${transaction['total_biaya']}.000',
                                        style: TextStyle(
                                          color: cardColor == Colors.green[600]
                                              ? Colors.black
                                              : Colors.white,
                                        ),
                                      ),
                                      Text(
                                        'Metode Pembayaran: ${transaction['metode_pembayaran']}',
                                        style: TextStyle(
                                          color: cardColor == Colors.green[600]
                                              ? Colors.black
                                              : Colors.white,
                                        ),
                                      ),
                                      Text(
                                        'Status Pembayaran: $statusPembayaran',
                                        style: TextStyle(
                                          color: cardColor == Colors.green[600]
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
          ],
        ));
  }
}
