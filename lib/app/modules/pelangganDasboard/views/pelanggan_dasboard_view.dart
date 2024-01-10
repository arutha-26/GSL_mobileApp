import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gsl/app/utils/bottom_navbar_pelanggan.dart';
import 'package:intl/intl.dart';

import '../../../controllers/auth_controllers.dart';
import '../../../routes/app_pages.dart';
import '../controllers/pelanggan_dasboard_controller.dart';

class PelangganDasboardView extends GetView<PelangganDasboardController> {
  PelangganDasboardView({super.key});

  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History Transaksi'),
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
          // const Text(
          //   'Selamat Datang di Green Spirit Laundry',
          //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          // ),
          // CarouselSlider(
          //   items: [
          //     Image.asset('images/banner_1.png'),
          //     Image.asset('images/banner_4.png'),
          //     Image.asset('images/banner_7_edit.png'),
          //     Image.asset('images/banner_5.png'),
          //   ],
          //   options: CarouselOptions(
          //     autoPlay: true,
          //     aspectRatio: 16 / 9,
          //     enlargeCenterPage: true,
          //     enableInfiniteScroll: true,
          //     autoPlayCurve: Curves.fastOutSlowIn,
          //     autoPlayAnimationDuration: const Duration(milliseconds: 2000),
          //     viewportFraction: 1,
          //   ),
          // ),
          // const SizedBox(height: 20),
          // const Text(
          //   'Data Transaksi',
          //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          // ),
          const SizedBox(height: 10),
          Expanded(
            child: Scrollbar(
              thickness: 7,
              scrollbarOrientation: ScrollbarOrientation.right,
              radius: const Radius.circular(12),
              trackVisibility: true,
              thumbVisibility: true,
              interactive: true,
              child: Obx(() {
                if (controller.isLoading.isTrue) {
                  return const Center(child: CircularProgressIndicator());
                } else if (controller.transactionHistory.isEmpty) {
                  return const Center(child: Text('Data Transaksi Tidak Ditemukan'));
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
                                            'Tanggal Diambil: ${transaction['tanggal_diambil'] != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(transaction['tanggal_diambil'])) : '-'}',
                                            style: TextStyle(
                                              color: cardColor == Colors.green
                                                  ? Colors.black
                                                  : Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'ID Transaksi: ${transaction['transaksi_id']}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: cardColor == Colors.green
                                              ? Colors.black
                                              : Colors.white,
                                        ),
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
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
          currentIndex: 1,
          onTap: (index) {
            // Handle navigation using Get
            switch (index) {
              case 0:
                Get.offAllNamed(
                    Routes.PELANGGANHOME); // Replace '/home' with your actual home route
                break;
              case 1:
                Get.offAllNamed(Routes
                    .PELANGGAN_DASBOARD); // Replace '/dashboard' with your actual dashboard route
                break;
              case 2:
                Get.offAllNamed(Routes
                    .PELANGGAN_PROFILE); // Replace '/profile' with your actual profile route
                break;
              default:
            }
          }),
    );
  }
//
// void _handleNavigationOwner(int index) {
//   switch (index) {
//     case 0:
//       Get.offAllNamed(Routes.OWNERHOME);
//       break;
//     case 1:
//       Get.offAllNamed(Routes.DASHBOARD_OWNER);
//       break;
//     case 2:
//       Get.offAllNamed(Routes.OWNERPROFILE);
//       break;
//     default:
//   }
// }
//
// void _handleNavigationKaryawan(int index) {
//   switch (index) {
//     case 0:
//       Get.offAllNamed(Routes.KARYAWANHOME);
//       break;
//     case 1:
//       Get.offAllNamed(Routes.KARYAWAN_DASHBOARD);
//       break;
//     case 2:
//       Get.offAllNamed(Routes.KARYAWANPROFILE);
//       break;
//     default:
//   }
// }
//
// void _handleNavigationPelanggan(int index) {
//   switch (index) {
//     case 0:
//       Get.offAllNamed(Routes.PELANGGANHOME);
//       break;
//     case 1:
//       Get.offAllNamed(Routes.PELANGGAN_DASBOARD);
//       break;
//     case 2:
//       Get.offAllNamed(Routes.PELANGGAN_PROFILE);
//       break;
//     default:
//   }
// }
}
