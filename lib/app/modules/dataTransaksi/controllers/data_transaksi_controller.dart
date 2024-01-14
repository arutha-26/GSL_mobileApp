import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DataTransaksiController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isHidden = true.obs;

  SupabaseClient client = Supabase.instance.client;

  RxList<Map<String, dynamic>> data = <Map<String, dynamic>>[].obs;
  RxInt currentPage = 1.obs;

  Rx<DateTime> startDate = Rx(DateTime.now());
  Rx<DateTime> endDate = Rx(DateTime.now());
  RxInt totalDataCount = 0.obs; // Variable to store the total data count

  Future<void> fetchDataWithDateRange({int page = 1}) async {
    try {
      isLoading.value = true;

      final response = await client
          .from('transaksi')
          .select(
              'id_transaksi, tanggal_datang, total_biaya, berat_laundry, status_cucian, status_pembayaran, metode_pembayaran, kembalian, nominal_bayar, tanggal_selesai, tanggal_diambil, id_karyawan_masuk, id_karyawan_keluar, is_hidden, edit_at, id_user(id_user, nama, no_telp, kategori, alamat)')
          .gte('tanggal_datang', '${startDate.value.toLocal()}')
          .lte('tanggal_datang', '${endDate.value.toLocal().add(const Duration(days: 1))}')
          .order('tanggal_datang', ascending: true)
          .execute();

      if (response != null && response.data is List) {
        data.value = (response.data as List)
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

        totalDataCount.value = data.length;

        final List<Map<String, dynamic>> newData = [];

        const itemsPerPage = 10;
        final startIdx = (page - 1) * itemsPerPage;

        if (startIdx < data.length) {
          for (var index = 0;
              index < itemsPerPage && (startIdx + index) < data.length;
              index++) {
            final item = data[startIdx + index];
            newData.add({
              ...item,
              'nomor_urut': startIdx + index + 1,
            });
          }
          data.value = newData;
        } else {
          data.value = [];
        }

        if (kDebugMode) {
          print('Fetched data: $data');
        }
      } else {
        if (kDebugMode) {
          print('Error: Invalid data format');
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error: $error');
      }
    } finally {
      isLoading.value = false;
    }
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
