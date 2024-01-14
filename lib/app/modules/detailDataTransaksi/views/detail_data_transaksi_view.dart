import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../controllers/detail_data_transaksi_controller.dart';

class DetailDataTransaksiView extends GetView<DetailDataTransaksiController> {
  DetailDataTransaksiView({super.key});

  final TextEditingController _harga = TextEditingController();

  String formatCurrency(num value) {
    NumberFormat currencyFormatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    return currencyFormatter.format(value);
  }

  @override
  Widget build(BuildContext context) {
    // Dapatkan data dari halaman sebelumnya
    final Map<String, dynamic> dataPanel = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Data Transaksi'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: controller.getDataTransaksi(dataPanel),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error.toString()}'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          }

          if (snapshot.data is! Map<String, dynamic>) {
            return const Center(child: Text('Invalid data format'));
          }

          final Map<String, dynamic> data = snapshot.data as Map<String, dynamic>;

          _harga.text = data['harga_kilo']?.toString() ?? '';

          return Column(children: [
            Container(
              height: 700,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Scrollbar(
                thickness: 3,
                radius: const Radius.circular(20),
                scrollbarOrientation: ScrollbarOrientation.right,
                thumbVisibility: true,
                trackVisibility: true,
                interactive: true,
                child: ListView(
                  padding: const EdgeInsets.all(5),
                  children: [
                    Image.asset(
                      'images/history_icon.png',
                      width: 150,
                      height: 150,
                    ),
                    const SizedBox(height: 5),

                    TextRow(
                        label: 'Transaksi ID', value: data['id_transaksi']?.toString() ?? '-'),
                    const SizedBox(height: 5),

                    TextRow(
                        label: 'Nama Karyawan Penerima',
                        value: data['id_karyawan_masuk']?.toString() ?? '-'),
                    const SizedBox(height: 5),

                    TextRow(
                        label: 'Nama Pelanggan',
                        value: data['id_user']['nama']?.toString().capitalizeFirst ?? '-'),
                    const SizedBox(height: 5),

                    TextRow(
                        label: 'Nomor Pelanggan',
                        value: data['id_user']['no_telp']?.toString() ?? '-'),
                    const SizedBox(height: 5),

                    TextRow(
                        label: 'Kategori Pelanggan',
                        value: data['id_user']['kategori']?.toString() ?? '-'),
                    const SizedBox(height: 5),

                    TextRow(
                        label: 'Alamat Pelanggan',
                        value: data['id_user']['alamat']?.toString() ?? '-'),
                    const SizedBox(height: 5),

                    TextRow(
                        label: 'Berat Laundry', value: '${data['berat_laundry']} Kg' ?? '-'),
                    const SizedBox(height: 5),

                    TextRow(
                        label: 'Layanan Laundry',
                        value: data['layanan_laundry']?.toString() ?? '-'),
                    const SizedBox(height: 5),

                    TextRow(
                        label: 'Metode Laundry',
                        value: data['metode_laundry']?.toString() ?? '-'),
                    const SizedBox(height: 5),

                    TextRow(
                        label: 'Tanggal Datang', value: formatDate(data['tanggal_datang'])),
                    const SizedBox(height: 5),

                    TextRow(
                      label: 'Total Biaya',
                      value: formatCurrency(data['total_biaya'] ?? 0),
                    ),

                    const SizedBox(height: 5),

                    TextRow(
                        label: 'Metode Pembayaran',
                        value: data['metode_pembayaran']?.toString() ?? '-'),
                    const SizedBox(height: 5),

                    TextRow(
                        label: 'Status Pembayaran',
                        value: getStatusPembayaran(data['status_pembayaran'])),
                    const SizedBox(height: 5),

                    TextRow(
                        label: 'Status Cucian',
                        value: data['status_cucian']?.toString().capitalizeFirst ?? '-'),
                    const SizedBox(height: 5),

                    TextRow(
                        label: 'Tanggal Selesai', value: formatDate(data['tanggal_selesai'])),
                    const SizedBox(height: 5),

                    TextRow(
                        label: 'Nama Karyawan Keluar',
                        value: data['id_karyawan_keluar']?.toString() ?? '-'),
                    const SizedBox(height: 5),

                    TextRow(
                        label: 'Tanggal Diambil', value: formatDate(data['tanggal_diambil'])),
                    const SizedBox(height: 5),
                    // Text fields for editing prices
                  ],
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  if (controller.getDataTransaksi(dataPanel).isBlank == false) {
                    await generateAndPrintInvoicePDF(dataPanel);
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
                child: const Text('Cetak Invoice')),
          ]);
        },
      ),
    );
  }

  String getStatusPembayaran(String? status) {
    if (status == 'belum_dibayar') {
      return 'Belum Dibayar';
    } else if (status == 'sudah_dibayar') {
      return 'Sudah Dibayar';
    }
    return status ?? '-';
  }

  String formatDate(String? dateString) {
    if (dateString == null) return '-';
    final DateTime date = DateTime.parse(dateString);
    return '${date.day}-${date.month}-${date.year}';
  }
}

class TextRow extends StatelessWidget {
  final String label;
  final String value;

  const TextRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(value),
      ],
    );
  }
}

Future<void> generateAndOpenInvoicePDF(data) async {
  final randomInvoiceNumber = Random().nextInt(99999) + 10000;
  // Generate PDF
  final pdf = pw.Document();

  // Add header with company information and invoice number
  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.roll80,
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
                  child: pw.Text('Id Invoice: ${data['id_transaksi']?.toString() ?? '-'}'),
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
                    'Nama Pelanggan: ${data['id_user']?.toString().capitalizeFirst ?? '-'}'),
                pw.Text(
                  'Alamat Pelanggan: ${data['id_user']?.toString() ?? '-'}',
                ),
                pw.Text('Telp (${data['id_user']?.toString() ?? '-'}'),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 20),
        pw.Column(
          children: [
            pw.Text('Id Transaksi', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text(data['id_transaksi']?.toString().capitalizeFirst ?? '-'),
            pw.Text('Tanggal Datang', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text(data['tanggal_datang']?.toString().capitalizeFirst ?? '-'),
            pw.Text('Metode Laundry', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text(data['metode_laundry']?.toString().capitalizeFirst ?? '-'),
            pw.Text('Layanan Laundry', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text(data['layanan_laundry']?.toString().capitalizeFirst ?? '-'),
            pw.Text('Berat Laundry', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text(data['berat_laundry']?.toString().capitalizeFirst ?? '-'),
            pw.Text('Status Cucian', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text(data['statu_cucian']?.toString().capitalizeFirst ?? '-'),
            pw.Text('Status Pembayaran', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text(data['status_pembayaran']?.toString().capitalizeFirst ?? '-'),
            pw.Text('Total Biaya', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text(data['total_biaya']?.toString().capitalizeFirst ?? '-'),
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
                pw.Text(data['id_user']?.toString().capitalizeFirst ?? '-'),
                pw.SizedBox(height: 50),
                pw.Text('Karyawan Green Spirit Laundry'),
              ],
            ),
          ],
        ),
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

Future<void> generateAndPrintInvoicePDF(data) async {
  final randomInvoiceNumber = Random().nextInt(99999) + 10000;

  Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async {
      return await Printing.convertHtml(
        format: format,
        html: '''
          <html>
            <head>
              <style>
                /* Add your custom styles here */
              </style>
            </head>
            <body>
              <!-- Your HTML content here -->
              <h1>Green Spirit Laundry</h1>
              <!-- ... your existing content ... -->
            </body>
          </html>
        ''',
      );
    },
  );
}
