import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../utils/bottom_navbar.dart';
import '../controllers/data_transaksi_controller.dart';

class DataTransaksiView extends GetView<DataTransaksiController> {
  DataTransaksiView({super.key});

  Future<void> _selectDate(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDateRange: DateTimeRange(
        start: DateTime.now(),
        end: DateTime.now(),
      ),
    );

    if (picked != null) {
      controller.startDate.value = picked.start;
      controller.endDate.value = picked.end;
      await controller.fetchDataWithDateRange();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Data Transaksi'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => _selectDate(context),
            child: Text('Select Date Range'),
          ),
          Obx(() {
            if (controller.isLoading.isTrue) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (controller.data.isEmpty) {
              return const Center(
                child: Text('Tidak Ada Data!'),
              );
            }

            List<DataColumn> columns = controller.data[0].keys.map((key) {
              return DataColumn(
                label: Text(controller.columnNames[key] ?? key.capitalizeFirst!),
              );
            }).toList();

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
                          'Navigating to: ${Routes.DETAILPANELTRANSAKSI}, with data: ${controller.data[idx]}',
                        );
                        Get.toNamed(
                          Routes.DETAILPANELTRANSAKSI,
                          arguments: controller.data[idx],
                        );
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
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        onTap: (index) {
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
      floatingActionButton: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () async {
                if (controller.currentPage.value > 1) {
                  controller.currentPage--;
                  await controller.fetchDataWithDateRange(page: controller.currentPage.value);
                  controller.data.refresh();
                }
              },
              child: const Icon(Icons.arrow_back),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () async {
                controller.currentPage++;
                await controller.fetchDataWithDateRange(page: controller.currentPage.value);
                controller.data.refresh();
              },
              child: const Icon(Icons.arrow_forward),
            ),
            const SizedBox(width: 10),
            Obx(() {
              return Text(
                'Page: ${controller.currentPage} / Total Data: ${controller.totalDataCount}',
                style: const TextStyle(fontSize: 16),
              );
            }),
          ],
        ),
      ),
    );
  }
}
