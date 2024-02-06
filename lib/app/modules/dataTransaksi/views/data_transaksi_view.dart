import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/data_transaksi_controller.dart';

class DataTransaksiView extends GetView<DataTransaksiController> {
  DataTransaksiView({super.key});

  final ScrollController _scrollController = ScrollController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      // confirmText: "Filter",
      saveText: "Filter",
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
      print('Data setelah pemanggilan fetchDataWithDateRange: ${controller.data}');
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
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () => _selectDate(context),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.greenAccent,
                minimumSize: const Size(220, 45),
              ),
              child: const Text('Pilih Tanggal Transaksi')),
          const SizedBox(
            height: 10,
          ),
          Obx(() {
            if (controller.isLoading.isTrue) {
              return const Center(
                heightFactor: 20,
                child: CircularProgressIndicator(),
              );
            }

            if (controller.data.isEmpty) {
              return const Center(
                child: Text('Tidak Ada Data!'),
              );
            }

            List<String> hiddenColumns = [
              'nomor_urut',
              'alamat',
              'id_transaksi',
              'tanggal_selesai',
              'id_user',
              'created_at',
              'is_hidden',
              'tanggal_diambil',
              'id_karyawan_keluar',
              'status_cucian',
              'status_pembayaran',
              'berat_laundry',
              'layanan_laundry',
              'metode_laundry',
              'kategori_pelanggan',
              'id_karyawan_masuk',
              'no_telp',
              'bukti_transfer'
            ];

            List<DataColumn> columns = [
              const DataColumn(label: Text('No.')), // Add a column for row number
              ...controller.data[0].keys
                  .where((key) =>
                      !hiddenColumns.contains(key) &&
                      key != 'id_transaksi' &&
                      key !=
                          'nomor_urut') // Exclude 'id' and 'nomor_urut' from being displayed
                  .map((key) => DataColumn(
                        label: Text(controller.columnNames[key] ?? key.capitalizeFirst!),
                      )),
            ];

            List<DataRow> rows = controller.data
                .asMap()
                .map((idx, row) {
                  // Filter out hidden columns
                  Map<String, dynamic> filteredRow = Map.from(row)
                    ..removeWhere((key, value) => hiddenColumns.contains(key));

                  // Ensure the number of cells matches the number of columns
                  assert(filteredRow.length == columns.length - 1,
                      'Mismatch in the number of cells and columns');

                  return MapEntry(
                    idx,
                    DataRow(
                      cells: [
                        DataCell(
                          Center(child: Text('${row['nomor_urut'] ?? ''}')),
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
                        ),
                        ...filteredRow.keys.map((key) {
                          return DataCell(
                            Center(
                              child: key == 'total_biaya'
                                  ? Align(
                                      alignment: Alignment.centerRight,
                                      child: Text('${filteredRow[key]}'),
                                    )
                                  : Text('${filteredRow[key]}', textAlign: TextAlign.center),
                            ),
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
                        }),
                      ],
                    ),
                  );
                })
                .values
                .toList();

            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Scrollbar(
                controller: _scrollController,
                // Provide the ScrollController here
                thickness: 5,
                radius: const Radius.circular(20),
                scrollbarOrientation: ScrollbarOrientation.bottom,
                thumbVisibility: true,
                trackVisibility: true,
                interactive: true,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  // Pass the same ScrollController to your scrollable widget
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: DataTable(
                      border: TableBorder.all(),
                      columns: columns,
                      rows: rows,
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
      floatingActionButton: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          alignment: Alignment.center,
          width: 380,
          height: 150,
          // color: Colors.greenAccent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            verticalDirection: VerticalDirection.down,
            children: [
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.print),
                            title: const Text('Print Data Lengkap'),
                            onTap: () async {
                              try {
                                await controller.fetchAllDataForPDF2();

                                if (controller.data.isNotEmpty) {
                                  controller
                                      .generateAndOpenInvoicePDF(controller.printDataInvoice);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('No data available to generate an invoice.'),
                                    ),
                                  );
                                }
                              } catch (error) {
                                if (kDebugMode) {
                                  print('Error generating PDF: $error');
                                }
                              }
                              Navigator.pop(
                                  context); // Close the bottom sheet after executing the function
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.print), // Replace with the appropriate icon
                            title: const Text('Print Data Simple'),
                            onTap: () async {
                              try {
                                await controller.fetchAllDataForPDF2();

                                if (controller.data.isNotEmpty) {
                                  controller.generateAndOpenInvoicePDFSimple(
                                      controller.printDataInvoice);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('No data available to generate an invoice.'),
                                    ),
                                  );
                                }
                              } catch (error) {
                                if (kDebugMode) {
                                  print('Error generating PDF: $error');
                                }
                              }

                              Navigator.pop(
                                  context); // Close the bottom sheet after executing the function
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  maximumSize: const Size(310, 40),
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.greenAccent,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.print),
                    SizedBox(width: 8), // Adjust the spacing between icon and text
                    Text('Print Data Transaksi'),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                verticalDirection: VerticalDirection.down,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        if (controller.currentPage.value > 1) {
                          controller.currentPage--;
                          await controller.fetchDataWithDateRange(
                              page: controller.currentPage.value);
                          // controller.data.refresh(); // Tidak perlu disegarkan di sini, jika sudah diakomodasi dalam fetchDataWithDateRange
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(150, 40),
                        foregroundColor: Colors.black,
                        backgroundColor: const Color(0xFFB0DCB9),
                      ),
                      child: const Text("Sebelumnya")),
                  const SizedBox(width: 10),
                  ElevatedButton(
                      onPressed: () async {
                        controller.currentPage++;
                        await controller.fetchDataWithDateRange(
                            page: controller.currentPage.value);
                        controller.data.refresh();
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(150, 40),
                        foregroundColor: Colors.black,
                        backgroundColor: const Color(0xFFB0DCB9),
                      ),
                      child: const Text("Selanjutnya")),
                  const SizedBox(width: 10),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                verticalDirection: VerticalDirection.down,
                children: [
                  Obx(() {
                    return Text(
                      'Halaman: ${controller.currentPage} / Total Data: ${controller.totalDataCount}',
                      style: const TextStyle(fontSize: 16),
                    );
                  }),
                ],
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }
}
