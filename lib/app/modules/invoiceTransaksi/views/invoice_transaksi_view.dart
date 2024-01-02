import 'dart:io';
import 'dart:math';

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

// TODO BUAT COLSPAN NYA, DATA ALAMAT PELANGGAN KURANG MUNGKIN BISA CEK LAGI DATABASENYA ATAU FUNC NYA AGAR BISA AMBIL DATA DARI USER YAA,

class InvoiceTransaksiView extends GetView<InvoiceTransaksiController> {
  InvoiceTransaksiView({Key? key}) : super(key: key);

  Future<void> selectDateRange(BuildContext context, TextEditingController startDateController,
      TextEditingController endDateController) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      // initialDateRange: DateTimeRange(
      //   start: DateTime.now(),
      //   end: DateTime.now(),
      // ),
    );

    if (picked != null) {
      // Update the format to 'yyyy-MM-dd'
      startDateController.text = DateFormat('yyyy-MM-dd').format(picked.start);
      endDateController.text = DateFormat('yyyy-MM-dd').format(picked.end);
    }
  }

  // Fungsi untuk menampilkan DatePicker
  Future<DateTime?> selectSingleDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.indigo[400], // Header background color
            hintColor: Colors.blue, // Selected day color
            colorScheme: const ColorScheme.light(primary: Colors.blue),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    return picked;
  }

  Future<void> generateAndOpenInvoicePDF() async {
    final randomInvoiceNumber = Random().nextInt(99999) + 10000;
    // Generate PDF
    final pdf = pw.Document();

    // Add header with company information and invoice number
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
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
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Header(
                    level: 0,
                    child: pw.Text('Invoice Number: $randomInvoiceNumber'),
                  ),
                ],
              ),
            ],
          ),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text(
                      'Nama Pelanggan: ${controller.invoiceData.isNotEmpty ? controller.invoiceData[0].namaPelanggan : ''}'),
                  pw.Text(
                    'Alamat Pelanggan: ${controller.alamatPelangganController.text}',
                  ),
                  pw.Text(
                    'Telp (+62${controller.invoiceData.isNotEmpty ? controller.invoiceData[0].nomorPelanggan : ''})',
                  ),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 20),
          pw.Table(
            border: pw.TableBorder.all(), // Add borders to the table
            children: [
              pw.TableRow(
                children: [
                  pw.Text('Id Transaksi', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('Tanggal Datang',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('Metode Laundry',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('Layanan Laundry',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('Berat Laundry',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('Status Cucian',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('Status Pembayaran',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('Total Biaya', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ],
              ),
              for (var data in controller.invoiceData)
                pw.TableRow(
                  // Apply red color for unpaid rows
                  decoration: (data.statusPembayaran == 'belum_dibayar')
                      ? const pw.BoxDecoration(color: PdfColor.fromInt(0xFFFFCCCC))
                      : null,
                  children: [
                    pw.Text('${data.idTransaksi}'),
                    pw.Text(formatDate(data.tanggalDatang)),
                    pw.Text(data.metodeLaundry),
                    pw.Text(data.layananLaundry),
                    pw.Text('${data.beratLaundry}Kg'),
                    pw.Text(data.statusCucian.capitalizeFirst ?? "Error Data"),
                    pw.Text(data.statusPembayaran == 'sudah_dibayar'
                        ? 'Sudah Dibayar'
                        : 'Belum Dibayar'),
                    pw.Text(
                        formatCurrency(double.tryParse(data.totalBiaya.toString()) ?? 0.0)),
                  ],
                ),
              // Footer row for total amount of unpaid transactions
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFFFFCCCC)),
                children: [
                  pw.Container(),
                  pw.Container(),
                  pw.Container(),
                  pw.Container(),
                  pw.Container(),
                  pw.Container(),
                  pw.Container(
                    alignment: pw.Alignment.center,
                    child: pw.Text('Total\n(Belum Dibayar)',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    width: 50, // Merge cells for the total label
                  ),
                  pw.Text(
                    formatCurrency(
                      controller.invoiceData
                          .where((data) => data.statusPembayaran == 'belum_dibayar')
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
    final file = File('${output.path}/invoice.pdf');
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
              TextField(
                enabled: false,
                autocorrect: false,
                controller: controller.namaKaryawanC,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: "Nama Karyawan",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 20,
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
                  child: Text(
                    controller.isLoading.isFalse ? "Cek Data Transaksi" : "Loading...",
                  ),
                ),
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
                      thumbVisibility: true,
                      child: ListView.builder(
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
                child: const Text('Generate Invoice'),
              ),
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
            Text("Nama Pelanggan: ${data.namaPelanggan}"),
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
        NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0).format(value);
    return currencyFormat;
  }
}
