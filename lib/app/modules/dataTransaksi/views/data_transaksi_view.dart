import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
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

      // Reset currentPage to 1 when selecting a new date
      controller.currentPage.value = 1;

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
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: const Color(0xFF22c55e),
                minimumSize: const Size(220, 45),
              ),
              child: const Text('Pilih Tanggal Transaksi')),
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

            List<String> hiddenColumns = [
              'transaksi_id',
              'tanggal_selesai',
              'created_at',
              'is_hidden',
              'tanggal_diambil',
              'nama_karyawan_keluar'
                  'status_cucian'
                  'total_biaya'
                  'status_pembayaran'
                  'berat_laundry'
                  'layanan_laundry'
                  'metode_laundry'
                  'kategori_pelanggan'
                  'nama_karyawan_masuk'
                  'nomor_pelanggan'
            ];

            List<DataColumn> columns = [
              const DataColumn(label: Text('No.')), // Add a column for row number
              ...controller.data[0].keys
                  .where((key) =>
                      !hiddenColumns.contains(key) &&
                      key != 'id') // Exclude 'id' from being displayed
                  .map((key) => DataColumn(
                        label: Text(controller.columnNames[key] ?? key.capitalizeFirst!),
                      ))
                  .toList(),
            ];

            List<DataRow> rows = controller.data
                .asMap()
                .map((idx, row) {
                  // Filter out hidden columns
                  Map<String, dynamic> filteredRow = Map.from(row)
                    ..removeWhere((key, value) => hiddenColumns.contains(key));

                  // Ensure the number of cells matches the number of columns
                  assert(filteredRow.length + 1 == columns.length,
                      'Mismatch in the number of cells and columns');

                  return MapEntry(
                    idx,
                    DataRow(
                      cells: [
                        DataCell(Center(child: Text('${idx + 1}.'))),
                        // Display the row number starting from 1
                        ...filteredRow.keys.map((key) {
                          return DataCell(
                            Center(child: Text('${filteredRow[key]}')),
                            onTap: () {
                              if (row != null) {
                                if (kDebugMode) {
                                  print(
                                    'Navigating to: ${Routes.DETAIL_DATA_TRANSAKSI}, with data: $row',
                                  );
                                }
                                Get.toNamed(
                                  Routes.DETAIL_DATA_TRANSAKSI,
                                  arguments: row,
                                );
                              } else {
                                if (kDebugMode) {
                                  print('Error: Data for row is null');
                                }
                              }
                            },
                          );
                        }).toList(),
                      ],
                    ),
                  );
                })
                .values
                .toList();

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
      floatingActionButton: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
                onPressed: () async {
                  if (controller.currentPage.value > 1) {
                    controller.currentPage--;
                    await controller.fetchDataWithDateRange(
                        page: controller.currentPage.value);
                    controller.data.refresh();
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: const Color(0xFF22c55e),
                ),
                child: const Icon(Icons.arrow_back)),
            const SizedBox(width: 10),
            ElevatedButton(
                onPressed: () async {
                  controller.currentPage++;
                  await controller.fetchDataWithDateRange(page: controller.currentPage.value);
                  controller.data.refresh();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: const Color(0xFF22c55e),
                ),
                child: const Icon(Icons.arrow_forward)),
            const SizedBox(width: 10),
            Obx(() {
              return Text(
                'Halaman: ${controller.currentPage} / Total Data: ${controller.totalDataCount}',
                style: const TextStyle(fontSize: 16),
              );
            }),
          ],
        ),
      ),
    );
  }
}
