import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../utils/InvoiceSearchWidget.dart';
import '../../../utils/invoiceData.dart';
import '../controllers/invoice_transaksi_controller.dart';

class InvoiceTransaksiView extends GetView<InvoiceTransaksiController> {
  InvoiceTransaksiView({super.key});

  final ScrollController _scrollController = ScrollController();

  Future<void> selectDateRange(BuildContext context, TextEditingController startDateController,
      TextEditingController endDateController) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      saveText: 'Filter',
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDateRange: DateTimeRange(
        start: DateTime.now(),
        end: DateTime.now(),
      ),
    );

    if (picked != null) {
      // Update the format to 'yyyy-MM-dd'
      startDateController.text = DateFormat('dd-MM-yyyy').format(picked.start);
      endDateController.text = DateFormat('dd-MM-yyyy').format(picked.end);
    }
  }

  // Fungsi untuk menampilkan DatePicker
  Future<DateTime?> selectSingleDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      confirmText: "Pilih",
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.greenAccent, // Header background color
            hintColor: Colors.tealAccent, // Selected day color
            colorScheme: const ColorScheme.light(primary: Colors.indigo),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    return picked;
  }

  Future<void> generateAndOpenInvoicePDF() async {
    final pdf = pw.Document();
    int rowIndex = 1;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a3.landscape,
        build: (context) => [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Green Spirit Laundry'),
                  pw.Text(
                    'Jl. Pura Masuka Gg. Jepun, Ungasan,\nKec. Kuta Sel., Kabupaten Badung, Bali 80361',
                  ),
                  pw.Text('Telp (+6281 23850 7062)'),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('LAPORAN TAGIHAN PELANGGAN'),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text('Invoice Periode',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(
                      '${formatDate(controller.startDate.toString())} - ${formatDate(controller.endDate.toString())}'),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 20),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Data Pelanggan',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('Nama Pelanggan: ${controller.nameController.text}'),
                  pw.Text(
                    'Alamat Pelanggan: ${controller.alamatPelangganController.text}',
                  ),
                  pw.Text(
                    'Telp (${controller.phoneController.text})',
                  ),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 20),
          pw.Table(
            defaultColumnWidth: const pw.IntrinsicColumnWidth(),

            // columnWidths: {
            //     0: const pw.FlexColumnWidth(1),
            //     1: const pw.FlexColumnWidth(1),
            //     2: const pw.FlexColumnWidth(1),
            //     3: const pw.FlexColumnWidth(1),
            //     4: const pw.FlexColumnWidth(1),
            //     5: const pw.FlexColumnWidth(1),
            //     6: const pw.FlexColumnWidth(1),
            //     7: const pw.FlexColumnWidth(1),
            //     8: const pw.FlexColumnWidth(1),
            //     9: const pw.FlexColumnWidth(1),
            //   },
            border: pw.TableBorder.all(), // Add borders to the table
            children: [
              pw.TableRow(
                children: [
                  pw.Text('No.',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  // pw.Text('Id\nTransaksi',
                  //     textAlign: pw.TextAlign.center,
                  //     style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('Tanggal\nDatang',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('Metode\nLaundry',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('Layanan\nLaundry',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('Berat\nLaundry',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  // pw.Text('Status\nCucian',
                  //     textAlign: pw.TextAlign.center,
                  //     style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  // pw.Text('Status\nPembayaran',
                  //     textAlign: pw.TextAlign.center,
                  //     style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('Total Biaya\n(Rp)',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ],
              ),
              for (var data in controller.invoiceData
                  .where((data) => data.statusPembayaran == 'Belum Lunas'))
                pw.TableRow(
                  children: [
                    pw.Text(textAlign: pw.TextAlign.center, '${rowIndex++}'),
                    pw.Text(textAlign: pw.TextAlign.center, formatDate(data.tanggalDatang)),
                    pw.Text(textAlign: pw.TextAlign.center, data.metodeLaundry),
                    pw.Text(textAlign: pw.TextAlign.center, data.layananLaundry),
                    pw.Text(textAlign: pw.TextAlign.center, '${data.beratLaundry}Kg'),
                    // pw.Text(
                    //     textAlign: pw.TextAlign.center,
                    //     data.statusCucian.capitalizeFirst ?? "Error Data"),
                    // pw.Text(textAlign: pw.TextAlign.center, data.statusPembayaran),
                    pw.Text(
                        textAlign: pw.TextAlign.right,
                        formatCurrency(double.tryParse(data.totalBiaya.toString()) ?? 0.0)),
                  ],
                ),
              pw.TableRow(
                // decoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFFFFCCCC)),
                children: [
                  pw.Container(),
                  pw.Container(),
                  pw.Container(),
                  pw.Container(),
                  pw.Container(
                    alignment: pw.Alignment.center,
                    child: pw.Text('Total Biaya (Rp)',
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    width: 50, // Merge cells for the total label
                  ),
                  pw.Text(
                    textAlign: pw.TextAlign.right,
                    formatCurrency(
                      controller.invoiceData
                          .where((data) => data.statusPembayaran == 'Belum Lunas')
                          .fold<double>(
                            0.0,
                            (total, data) =>
                                total + (double.tryParse(data.totalBiaya.toString()) ?? 0.0),
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 20),
          pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Jatuh Tempo: ${controller.jatuhTempoController.text}',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(
                      'Catatan:\n 1. Pembayaran dapat dilakukan melalui transfer ke rekening\n A/N Green Spirit Laundry di BCA dengan nomor xxx.xxx.xxxx.\n '
                      '2. Keterlambatan pembayaran akan dikenakan bunga.\n 3. Hubungi kami jika ada kendala atau pertanyaan.\n'
                      'CP: Green Spirit Laundry - +62897913414121121',
                    ),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text('Tanggal: ${DateFormat('dd-MM-yyyy').format(DateTime.now())}'),
                    pw.Text(controller.namaKaryawanC.text),
                    pw.SizedBox(height: 50),
                    pw.Text('Karyawan Green Spirit Laundry'),
                  ],
                )
              ]),
        ],
      ),
    );

    // Save PDF to a temporary file
    final output = await getTemporaryDirectory();
    final file = File(
        '${output.path}/Laporan_Tagihan_Pelanggan_${controller.nameController.text}_Periode_${formatDate(controller.startDate.toString())} - ${formatDate(controller.endDate.toString())}.pdf');
    await file.writeAsBytes(await pdf.save());

    // Open the generated PDF file
    OpenFile.open(file.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cetak Data Transaksi'),
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
      body: FutureBuilder(
        future: controller.getDataKaryawan(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(10),
            children: [
              const SizedBox(
                height: 10,
              ),
              InvoiceSearchWidget(
                nameController: controller.nameController,
                phoneController: controller.phoneController,
                kategoriController: controller.kategoriController,
                invoiceTransaksiController: controller,
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                keyboardType: TextInputType.none,
                controller: controller.nameController,
                decoration: const InputDecoration(
                  labelText: "Nama Pelanggan",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: controller.startDateController,
                decoration: const InputDecoration(
                  labelText: "Tanggal Transaksi Awal",
                  border: OutlineInputBorder(),
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  selectDateRange(
                      context, controller.startDateController, controller.endDateController);
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: controller.endDateController,
                decoration: const InputDecoration(
                  labelText: "Tanggal Transaksi Akhir",
                  border: OutlineInputBorder(),
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  selectDateRange(
                      context, controller.startDateController, controller.endDateController);
                },
              ),
              const SizedBox(height: 20),
              TextField(
                controller: controller.jatuhTempoController,
                decoration: const InputDecoration(
                  labelText: "Tanggal Jatuh Tempo",
                  border: OutlineInputBorder(),
                ),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  final selectedDate = await selectSingleDate(context);
                  if (selectedDate != null) {
                    controller.jatuhTempoController.text = formatDatetwo(selectedDate);
                  }
                },
              ),
              const SizedBox(height: 20),
              Obx(
                () => ElevatedButton(
                    onPressed: () async {
                      if (controller.isLoading.isFalse) {
                        await controller.fetchDataTransaksi();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: const Color(0xFF22c55e),
                    ),
                    child: Text(
                      controller.isLoading.isFalse ? "Cek Data Transaksi" : "Loading...",
                    )),
              ),
              const SizedBox(height: 20),
              // Display fetched data in cards
              Obx(() {
                if (controller.invoiceData.isNotEmpty) {
                  Get.snackbar(
                    'Data Masuk',
                    'Ada Data Transaksi',
                    // snackPosition: SnackPosition.TOP,
                    colorText: Colors.white,
                    backgroundColor: Colors.greenAccent,
                  );
                  return SizedBox(
                    height: 200, // Set the desired height
                    child: Scrollbar(
                      controller: _scrollController,
                      thumbVisibility: true,
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: controller.invoiceData.length,
                        itemBuilder: (context, index) {
                          return buildDataCard(controller.invoiceData[index]);
                        },
                      ),
                    ),
                  );
                } else {
                  Get.snackbar(
                    'Data Kosong',
                    'Tidak Ada Data Transaksi',
                    snackPosition: SnackPosition.BOTTOM,
                    colorText: Colors.white,
                    backgroundColor: Colors.redAccent,
                  );
                  return const Center(child: Text('Tidak Ada Data Untuk Ditampilkan'));
                }
              }),
              // Add the button to generate the invoice PDF
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (controller.invoiceData.isNotEmpty) {
                      await generateAndOpenInvoicePDF();
                    } else {
                      // Show a message that there's no data to generate an invoice
                      // You can customize this based on your requirements
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('No data available to generate an invoice.'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: const Color(0xFF22c55e),
                  ),
                  child: const Text('Buat Invoice')),
            ],
          );
        },
      ),
    );
  }

  Widget buildDataCard(InvoiceData data) {
    // Customize this method based on the structure of your InvoiceData class
    return Card(
      child: ListTile(
        title: Text("Transaction ID: ${data.idTransaksi}"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nama Pelanggan: ${controller.nameController.text.toString()}"),
            Text("Alamat: ${controller.alamatPelangganController.text}"),
            Text("Tanggal Datang: ${formatDate(data.tanggalDatang)}"),
            // Add more ListTile widgets for other data fields
          ],
        ),
      ),
    );
  }

  // Fungsi untuk memformat tanggal menjadi string
  String formatDatetwo(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  String formatDate(String date) {
    try {
      // Assuming date is in YYYY-MM-DD format
      DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(date);
      return DateFormat('dd-MM-yyyy').format(parsedDate); // Convert to YYYY-MM-DD format
    } catch (e) {
      if (kDebugMode) {
        print("Error parsing date: $e");
      }
      return "";
    }
  }

  String formatCurrency(double value) {
    final currencyFormat =
        NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0).format(value);
    return currencyFormat;
  }
}
