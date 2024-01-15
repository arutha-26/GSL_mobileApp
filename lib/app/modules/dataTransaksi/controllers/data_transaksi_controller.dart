import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:supabase_flutter/supabase_flutter.dart';

class DataTransaksiController extends GetxController {
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

  RxBool isLoading = false.obs;
  RxBool isHidden = true.obs;

  SupabaseClient client = Supabase.instance.client;

  RxList<Map<String, dynamic>> data = <Map<String, dynamic>>[].obs;
  RxInt currentPage = 1.obs;

  Rx<DateTime> startDate = Rx(DateTime.now());
  Rx<DateTime> endDate = Rx(DateTime.now());
  RxInt totalDataCount = 0.obs; // Variable to store the total data count
  bool isFetchingData = false;

  List<Map<String, dynamic>> printDataInvoice = [];

  Future<void> fetchAllDataForPDF2() async {
    try {
      isLoading.value = true;

      final response = await client
          .from('transaksi')
          .select(
              'id_transaksi, tanggal_datang, total_biaya, berat_laundry, status_cucian, status_pembayaran, layanan_laundry, metode_laundry, metode_pembayaran, kembalian, nominal_bayar, tanggal_selesai, tanggal_diambil, id_karyawan_masuk, id_karyawan_keluar, is_hidden, edit_at, id_user(id_user, nama, no_telp, kategori, alamat)')
          .gte('tanggal_datang', '${startDate.value.toLocal()}')
          .lte('tanggal_datang', '${endDate.value.toLocal().add(const Duration(days: 1))}')
          .order('tanggal_datang', ascending: true)
          .execute();

      if (response != null && response.data is List) {
        print('Response data: ${response.data}');

        List<Map<String, dynamic>> printData = (response.data as List)
            .map<Map<String, dynamic>>((item) {
              try {
                final editAt = DateTime.parse(item['tanggal_datang']);
                final formattedDate = '${editAt.day}-${editAt.month}-${editAt.year}';
                final berat = (item['berat_laundry'] as num?) ?? 0;
                final formattedBerat = '$berat Kg';
                final harga = (item['total_biaya']) ?? 0;
                NumberFormat currencyFormatter =
                    NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);
                final formatHarga = currencyFormatter.format(harga);
                final cucian = (item['status_cucian'] as String?) ?? 'N/A';
                final formattedCucian = cucian.capitalizeFirst;
                final statusPembayaran = item['status_pembayaran'] as String? ?? 'N/A';
                final formattedStatusP =
                    statusPembayaran == 'sudah_dibayar' ? 'Sudah Dibayar' : 'Belum Dibayar';
                final nama = item['id_user']['nama']?.toString().capitalizeFirst ?? '';
                final noTelp = item['id_user']['no_telp']?.toString() ?? '';
                final alamat = item['id_user']['alamat']?.toString() ?? '';
                final idKM = item['id_karyawan_masuk']?.toString() ?? '';
                final idKK = item['id_karyawan_keluar']?.toString() ?? '';

                return {
                  'nama': nama,
                  'no_telp': noTelp,
                  'alamat': alamat,
                  'id_transaksi': item['id_transaksi'],
                  'total_biaya': item['total_biaya'],
                  'tanggal_datang': formattedDate,
                  'berat_laundry': formattedBerat,
                  'layanan_laundry': item['layanan_laundry'],
                  'metode_laundry': item['metode_laundry'],
                  'status_cucian': formattedCucian,
                  'status_pembayaran': formattedStatusP,
                  'id_karyawan_masuk': idKM.toString(),
                  'id_karyawan_keluar': idKK.toString(),
                };
              } catch (e) {
                if (kDebugMode) {
                  print('Error processing item: $item');
                }
                if (kDebugMode) {
                  print('Error details: $e');
                }
                return {}; // Return an empty map for problematic items
              }
            })
            .where((item) => item.isNotEmpty)
            .toList();

        // Set data.value to newData
        printDataInvoice = printData;
      } else {
        if (kDebugMode) {
          print('Error: Invalid data format');
        }
        return;
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error: $error');
      }
      return;
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllDataForPDF() async {
    try {
      isLoading.value = true;

      final response = await client
          .from('transaksi')
          .select(
              'id_transaksi, tanggal_datang, total_biaya, berat_laundry, status_cucian, status_pembayaran, layanan_laundry, metode_laundry, metode_pembayaran, kembalian, nominal_bayar, tanggal_selesai, tanggal_diambil, id_karyawan_masuk, id_karyawan_keluar, is_hidden, edit_at, id_user(id_user, nama, no_telp, kategori, alamat)')
          .gte('tanggal_datang', '${startDate.value.toLocal()}')
          .lte('tanggal_datang', '${endDate.value.toLocal().add(const Duration(days: 1))}')
          .order('tanggal_datang', ascending: true)
          .execute();

      if (response != null && response.data is List) {
        print('Response data: ${response.data}');

        List<Map<String, dynamic>> newData = (response.data as List)
            .map<Map<String, dynamic>>((item) {
              try {
                final editAt = DateTime.parse(item['tanggal_datang']);
                final formattedDate = '${editAt.day}-${editAt.month}-${editAt.year}';
                final berat = (item['berat_laundry'] as num?) ?? 0;
                final formattedBerat = '$berat Kg';
                final harga = (item['total_biaya'] as num?) ?? 0;
                NumberFormat currencyFormatter =
                    NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);
                final formatHarga = currencyFormatter.format(harga);
                final cucian = (item['status_cucian'] as String?) ?? 'N/A';
                final formattedCucian = cucian.capitalizeFirst;
                final statusPembayaran = item['status_pembayaran'] as String? ?? 'N/A';
                final formattedStatusP =
                    statusPembayaran == 'sudah_dibayar' ? 'Sudah Dibayar' : 'Belum Dibayar';
                final nama = item['id_user']['nama']?.toString().capitalizeFirst ?? '';
                final noTelp = item['id_user']['no_telp']?.toString() ?? '';
                final alamat = item['id_user']['alamat']?.toString() ?? '';
                final idKM = item['id_karyawan_masuk']?.toString() ?? '';
                final idKK = item['id_karyawan_keluar']?.toString() ?? '';

                return {
                  'nama': nama,
                  'no_telp': noTelp,
                  'alamat': alamat,
                  'id_transaksi': item['id_transaksi'],
                  'total_biaya': formatHarga,
                  'tanggal_datang': formattedDate,
                  'berat_laundry': formattedBerat,
                  'layanan_laundry': item['layanan_laundry'],
                  'metode_laundry': item['metode_laundry'],
                  'status_cucian': formattedCucian,
                  'status_pembayaran': formattedStatusP,
                  'id_karyawan_masuk': idKM.toString(),
                  'id_karyawan_keluar': idKK.toString(),
                };
              } catch (e) {
                if (kDebugMode) {
                  print('Error processing item: $item');
                }
                if (kDebugMode) {
                  print('Error details: $e');
                }
                return {}; // Return an empty map for problematic items
              }
            })
            .where((item) => item.isNotEmpty)
            .toList();

        // Set data.value to newData
        data.value = newData;

        return paginateData(newData);
      } else {
        if (kDebugMode) {
          print('Error: Invalid data format');
        }
        return [];
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error: $error');
      }
      return [];
    } finally {
      isLoading.value = false;
    }
  }

  List<Map<String, dynamic>> paginateData(List<Map<String, dynamic>> newData,
      {int page = 1, int itemsPerPage = 10}) {
    final List<Map<String, dynamic>> paginatedData = [];
    final startIdx = (page - 1) * itemsPerPage;

    if (startIdx < newData.length) {
      for (var index = startIdx;
          index < startIdx + itemsPerPage && index < newData.length;
          index++) {
        final item = newData[index];
        paginatedData.add({
          ...item,
          'nomor_urut': index + 1,
        });
      }
    }

    return paginatedData;
  }

  Future<void> fetchDataWithDateRange({int page = 1}) async {
    try {
      isLoading.value = true;

      // Fetch all data for PDF generation and get paginated data for UI
      final List<Map<String, dynamic>> paginatedData = await fetchAllDataForPDF();
      totalDataCount.value = data.length;

      data.value = paginateData(paginatedData, page: page);

      if (kDebugMode) {
        print('Fetched data: $data');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error Fetch Data Pagination: $error');
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> generateAndOpenInvoicePDF(List<Map<String, dynamic>> data) async {
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
          pw.SizedBox(height: 20),
          pw.Table(
            border: pw.TableBorder.all(), // Add borders to the table
            children: [
              pw.TableRow(
                children: [
                  pw.Text('Id Transaksi', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('Nama Pelanggan',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  // pw.Text('Alamat Pelanggan',
                  //     style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('No Telp', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
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
              for (var data in data)
                pw.TableRow(
                  // Apply red color for unpaid rows
                  decoration: (data['status_pembayaran'] == 'belum_dibayar')
                      ? const pw.BoxDecoration(color: PdfColor.fromInt(0xFFFF0000))
                      : null,
                  children: [
                    pw.Text('${data['id_transaksi']}'),
                    pw.Text('${data['nama']}'),
                    // pw.Text('${data['alamat']}'),
                    pw.Text('${data['no_telp']}'),
                    pw.Text(formatDate(data['tanggal_datang'])),
                    pw.Text(data['metode_laundry']),
                    pw.Text(data['layanan_laundry']),
                    pw.Text('${data['berat_laundry']}Kg'),
                    pw.Text(data['status_cucian'] ?? "Error Data"),
                    pw.Text(data['status_pembayaran'] == 'sudah_dibayar'
                        ? 'Sudah Dibayar'
                        : 'Belum Dibayar'),
                    pw.Text(formatCurrency(
                        double.tryParse(data['total_biaya'].toString()) ?? 0.0)),
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
                      data
                          .where((data) => data['status_pembayaran'] == 'belum_dibayar')
                          .fold<double>(
                            0.0,
                            (total, data) =>
                                total +
                                (double.tryParse(data['total_biaya'].toString()) ?? 0.0),
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
                  // pw.Text(
                  //   'Jatuh Tempo: ${controller.jatuhTempoController.text}',
                  //   style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  // ),
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
                  pw.Text(
                    'Tanggal: ${DateFormat('dd-MM-yyyy').format(DateTime.now())}',
                  ),
                  // pw.Text(controller.namaKaryawanC.text),
                  pw.SizedBox(height: 50),
                  pw.Text('Karyawan Green Spirit Laundry'),
                ],
              )
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

  final Map<String, String> columnNames = {
    'id_transaksi': 'Id Transaksi',
    'nama_pelanggan': 'Nama Pelanggan',
    'nomor_pelanggan': 'Nomor Pelanggan',
    'kategori_pelanggan': 'Kategori Pelanggan',
    'id_karyawan_masuk': 'Id Karyawan Penerima',
    'metode_laundry': 'Metode Laundry',
    'layanan_laundry': 'Layanan Laundry',
    'berat_laundry': 'Berat Laundry',
    'total_biaya': 'Total Biaya',
    'metode_pembayaran': 'Metode Pembayaran',
    'status_pembayaran': 'Status Pembayaran',
    'tanggal_datang': 'Tanggal Datang',
    'tanggal_selesai': 'Tanggal Selesai',
    'status_cucian': 'Status Cucian',
    'is_hidden': 'Is Hidden',
    'edit_at': 'Edit At'
  };
}
