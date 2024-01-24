import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DetailDataTransaksiController extends GetxController {
  SupabaseClient client = Supabase.instance.client;
  RxBool isLoading = false.obs;

  Future<String> fetchEmployeeName(int employeeId) async {
    try {
      var userResponse =
          await client.from("user").select('nama').match({"id_user": employeeId}).execute();

      return userResponse.data.isNotEmpty ? userResponse.data.first['nama'].toString() : '';
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching user data: $error');
      }
      return ''; // Return an empty string in case of failure
    }
  }

  Future<Map<String, dynamic>> getDataTransaksi(Map<String, dynamic> dataPanel) async {
    try {
      var response = await client
          .from("transaksi")
          .select(
              'id_transaksi, tanggal_datang, total_biaya, berat_laundry, layanan_laundry, metode_laundry, status_cucian, status_pembayaran, metode_pembayaran, tanggal_selesai, tanggal_diambil, id_karyawan_masuk, id_karyawan_keluar, is_hidden, edit_at, id_user(id_user, nama, no_telp, kategori, alamat)')
          .match({"id_transaksi": dataPanel['id_transaksi']}).execute();

      if (response.status == 200 && response.data != null && response.data.isNotEmpty) {
        var transaksiData = response.data.first;

        // Fetch the employee names separately using the id_karyawan_masuk and id_karyawan_keluar
        var idMasuk = transaksiData['id_karyawan_masuk'];
        var idKeluar = transaksiData['id_karyawan_keluar'];

        if (idMasuk != null && idMasuk is int) {
          transaksiData['id_karyawan_masuk'] = await fetchEmployeeName(idMasuk);
        }

        if (idKeluar != null && idKeluar is int) {
          transaksiData['id_karyawan_keluar'] = await fetchEmployeeName(idKeluar);
        }

        return transaksiData;
      } else {
        if (kDebugMode) {
          print('No data found or bad response: ${response.toString()}');
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching data: $error');
      }
    }
    return {}; // Return an empty map in case of failure
  }

  Future<void> generateAndOpenInvoicePDF(data) async {
    String formatCurrency(double value) {
      final currencyFormat =
          NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0).format(value);
      return currencyFormat;
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

    final pdf = pw.Document();

    // Helper function to create a styled text row
    pw.Widget styledTextRow(String label, String value) {
      return pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(width: 10),
          pw.Text(value),
        ],
      );
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: const PdfPageFormat(8 * PdfPageFormat.cm, 20 * PdfPageFormat.cm,
            marginAll: 0.5 * PdfPageFormat.cm),
        build: (context) => [
          pw.Center(
            child: pw.Text(
              'Id Invoice: ${data['id_transaksi']?.toString() ?? '-'}',
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.Divider(
              height: 1,
              borderStyle: pw.BorderStyle.solid,
              thickness: 1,
              color: PdfColors.black),
          pw.SizedBox(height: 5),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(
                'Green Spirit Laundry',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                  'Jl. Pura Masuka Gg. Jepun, Ungasan,\nKec. Kuta Sel., Kabupaten Badung, Bali 80361',
                  textAlign: pw.TextAlign.center),
              pw.Text('Telp (+6281 23850 7062)'),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Divider(
              height: 1,
              borderStyle: pw.BorderStyle.solid,
              thickness: 1,
              color: PdfColors.black),
          pw.SizedBox(height: 5),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(
                'Customer Data',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                data['id_user']['nama']?.toString().capitalizeFirst ?? '-',
                overflow: pw.TextOverflow.visible, // Truncate with ellipsis if too long
              ),
              pw.Text(
                (data['id_user']['alamat']?.toString() ?? '-'),
                maxLines: null, // Limit to 3 lines
                overflow: pw.TextOverflow.visible, // Clip overflowed text
                softWrap: true,
                textAlign: pw.TextAlign.center,
              ),
              pw.Text(
                data['id_user']['no_telp']?.toString() ?? '-',
                overflow: pw.TextOverflow.visible, // Truncate with ellipsis if too long
              ),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Divider(
              height: 1,
              borderStyle: pw.BorderStyle.solid,
              thickness: 1,
              color: PdfColors.black),
          pw.SizedBox(height: 5),
          pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.SizedBox(height: 5),
                pw.Text('Detail Transaksi',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                styledTextRow('Tanggal:', formatDate(data['tanggal_datang']) ?? '-'),
                styledTextRow('Metode Laundry:',
                    data['metode_laundry']?.toString().capitalizeFirst ?? '-'),
                styledTextRow('Layanan Laundry:',
                    data['layanan_laundry']?.toString().capitalizeFirst ?? '-'),
                styledTextRow('Berat Laundry:', '${data['berat_laundry']}Kg' ?? '-'),
                styledTextRow('Status Cucian:', data['status_cucian']?.toString() ?? '-'),
                styledTextRow(
                    'Status Pembayaran:',
                    data['status_pembayaran']?.toString().capitalize == 'sudah_dibayar'
                        ? 'Sudah Dibayar'
                        : 'Belum Dibayar' ?? '-'),
                styledTextRow('Total Biaya:',
                    formatCurrency(double.tryParse(data['total_biaya'].toString()) ?? 0.0)),
              ]),
          pw.SizedBox(height: 5),
          pw.Divider(
              height: 1,
              borderStyle: pw.BorderStyle.solid,
              thickness: 1,
              color: PdfColors.black),
          pw.SizedBox(height: 5),
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
          pw.SizedBox(height: 5),
          pw.Divider(
              height: 1,
              borderStyle: pw.BorderStyle.solid,
              thickness: 1,
              color: PdfColors.black),
          pw.SizedBox(height: 5),
          pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text('${DateFormat('dd-MM-yyyy').format(DateTime.now())}'),
                    pw.Text(data['id_karyawan_masuk']?.toString().capitalizeFirst ?? '-'),
                    pw.SizedBox(height: 50),
                    pw.Text('Karyawan Green Spirit Laundry'),
                  ],
                ),
              ])
        ],
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/invoice.pdf');
    await file.writeAsBytes(await pdf.save());

    OpenFile.open(file.path);
  }

// MUNGKIN DIGUNAKAN, FUNC INI BLM SEPENUHNYA SELESAI!
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
}
