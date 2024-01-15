import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:supabase_flutter/supabase_flutter.dart';

class DataTransaksiController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getDataKaryawan();
    if (kDebugMode) {
      print('Nama Karyawan setelah getDataKaryawan(): ${namaKaryawanC.text}');
    }
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

  RxBool isLoading = false.obs;
  RxBool isHidden = true.obs;

  SupabaseClient client = Supabase.instance.client;

  RxList<Map<String, dynamic>> data = <Map<String, dynamic>>[].obs;
  RxInt currentPage = 1.obs;
  TextEditingController namaKaryawanC = TextEditingController();

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

  Future<void> getDataKaryawan() async {
    List<dynamic> res =
        await client.from("user").select().match({"uid": client.auth.currentUser!.id});
    Map<String, dynamic> user = (res).first as Map<String, dynamic>;
    namaKaryawanC.text = user["nama"];
  }

  Future<void> generateAndOpenInvoicePDF(List<Map<String, dynamic>> data) async {
    final randomInvoiceNumber = Random().nextInt(99999) + 10000;
    await getDataKaryawan();
    if (kDebugMode) {
      print('Nama Karyawan setelah getDataKaryawan(): ${namaKaryawanC.text}');
    }

    final unpaidData =
        data.where((item) => item['status_pembayaran'] == 'Belum Dibayar').toList();
    final totalUnpaid = unpaidData.fold<double>(
      0.0,
      (total, item) => total + (double.tryParse(item['total_biaya'].toString()) ?? 0.0),
    );
    // Generate PDF
    final pdf = pw.Document();
    // Declare rowIndex inside the function
    int rowIndex = 1;

    // Add header with company information and invoice number
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
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text('Invoice Periode',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(
                      '${formatDate(startDate.toString())} - ${formatDate(endDate.toString())}'),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 20),
          pw.Table(
            defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
            // defaultColumnWidth: const pw.IntrinsicColumnWidth(),
            columnWidths: {
              0: const pw.FlexColumnWidth(1),
              1: const pw.FlexColumnWidth(2),
              2: const pw.FlexColumnWidth(2),
              3: const pw.FlexColumnWidth(2),
              4: const pw.FlexColumnWidth(2),
              5: const pw.FlexColumnWidth(2),
              6: const pw.FlexColumnWidth(2),
              7: const pw.FlexColumnWidth(2),
              8: const pw.FlexColumnWidth(2),
              9: const pw.FlexColumnWidth(2),
              10: const pw.FlexColumnWidth(2),
            },
            border: pw.TableBorder.all(), // Add borders to the table
            children: [
              pw.TableRow(
                children: [
                  pw.Text('No.',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('Id\nTransaksi',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('Nama\nPelanggan',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  // pw.Text('Alamat Pelanggan',
                  //     style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('No\nTelp',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
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
                  pw.Text('Status\nCucian',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('Status\nPembayaran',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('Total\nBiaya',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ],
              ),
              for (var data in data)

                // for (int index = 0; index < data.length; index++)
                pw.TableRow(
                  // Apply red color for unpaid rows
                  decoration: (data['status_pembayaran'] == 'Belum Dibayar')
                      ? const pw.BoxDecoration(color: PdfColor.fromInt(0xFFFFCCCC))
                      : null,
                  children: [
                    centeredText('${rowIndex++}'),
                    centeredText('${data['id_transaksi']}'),
                    centeredText('${data['nama']}'),
                    // pw.Text('${data['alamat']}'),
                    centeredText('${data['no_telp']}'),
                    centeredText(formatDate(data['tanggal_datang'])),
                    centeredText(data['metode_laundry']),
                    centeredText(data['layanan_laundry']),
                    centeredText('${data['berat_laundry']}'),
                    centeredText(data['status_cucian'] ?? "Error Data"),
                    centeredText(data['status_pembayaran']),
                    centeredText(formatCurrency(
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
                  pw.Container(),
                  pw.Container(),
                  pw.Container(),
                  pw.Container(
                    alignment: pw.Alignment.center,
                    child: pw.Text('Total\n(Belum Dibayar)',
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    width: 50, // Merge cells for the total label
                  ),
                  pw.Text(textAlign: pw.TextAlign.center, formatCurrency(totalUnpaid)),
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
                    '${DateFormat('dd-MM-yyyy').format(DateTime.now())}',
                  ),
                  pw.Text(namaKaryawanC.text.toString()),
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

  pw.Widget _colspanText(String text, {int colspan = 1, pw.FontWeight? fontWeight}) {
    return pw.Container(
      alignment: pw.Alignment.center,
      child: pw.Text(text, style: pw.TextStyle(fontWeight: fontWeight)),
      width: colspan * 100.0, // Sesuaikan dengan lebar yang diinginkan
    );
  }

  pw.Widget centeredText(String text, {pw.FontWeight? fontWeight}) {
    return pw.Container(
      alignment: pw.Alignment.center,
      child: pw.Text(text, style: pw.TextStyle(fontWeight: fontWeight)),
    );
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
