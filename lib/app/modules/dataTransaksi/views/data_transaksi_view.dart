import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controllers.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/bottom_navbar.dart';
import '../controllers/data_transaksi_controller.dart';

// TODO
/*
* TAMBAHKAN FILTER
* TAMBAHKAN PAGENATION
* PIKIRKAN LAGI DATA YANG HARUS DITAMPILKAN APA SAJA
*/

class DataTransaksiView extends GetView<DataTransaksiController> {
  DataTransaksiView({Key? key}) : super(key: key);

  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Transaksi'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.isTrue) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.data.isEmpty) {
          return const Center(
            child: Text('No data available.'),
          );
        }

        // Define the columns using the columnNames mapping
          List<DataColumn> columns = controller.data[0].keys.map((key) {
            return DataColumn(
              label: Text(controller.columnNames[key] ?? key.capitalizeFirst!),
            );
          }).toList();

          // Define the rows based on the data
          List<DataRow> rows = controller.data.asMap().entries.map((entry) {
            int idx = entry.key;
            Map<String, dynamic> row = entry.value;

            return DataRow(
              cells: row.keys.map((key) {
                return DataCell(
                  Center(child: Text('${row[key]}')),
                  onTap: () {
                    if (controller.data[idx] != null) {
                      print(
                          'Navigating to: ${Routes.DETAILPANELTRANSAKSI}, with data: ${controller.data[idx]}');
                      Get.toNamed(Routes.DETAILPANELTRANSAKSI,
                          arguments: controller.data[idx]);
                    } else {
                      print('Error: Data for index $idx is null');
                    }
                  },
                );
              }).toList(),
            );
          }).toList();

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: columns,
              rows: rows,
            ),
          ),
        );
      }),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          // Handle navigation using Get
          switch (index) {
            case 0:
              Get.offAllNamed(Routes.OWNERHOME);
              break;
            case 1:
              Get.offAllNamed(Routes.DASHBOARD_OWNER);
              break;
            case 2:
              Get.offAllNamed(Routes.OWNERPROFILE);
              break;
            default:
          }
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () async {
              if (controller.currentPage.value > 1) {
                controller.currentPage--;
                await controller.fetchData(page: controller.currentPage.value);
                // Update UI
              }
            },
            child: const Icon(Icons.arrow_back),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () async {
              controller.currentPage++;
              await controller.fetchData(page: controller.currentPage.value);
              // Update UI
            },
            child: const Icon(Icons.arrow_forward),
          ),
          const SizedBox(width: 20),
          Obx(() {
            return Row(
              children: [
                Text('Page: ${controller.currentPage}'),
                const SizedBox(width: 20),
                if (controller.isLoading.isTrue) ...{
                  const CircularProgressIndicator(),
                }
              ],
            );
          }),
        ],
      ),
    );
  }
}
