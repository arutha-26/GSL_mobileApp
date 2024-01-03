import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
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
          .select('*')
          .gte('tanggal_datang', '${startDate.value.toLocal()}')
          .lte('tanggal_datang', '${endDate.value.toLocal().add(const Duration(days: 1))}')
          .execute(); // Fetch all data for the date range

      if (response != null && response.data != null && response.data is List) {
        data.value = (response.data as List).map((item) {
          final editAt = DateTime.parse(item['tanggal_datang'] as String);
          final formattedDate = '${editAt.day}-${editAt.month}-${editAt.year}';
          final berat = (item['berat_laundry'] as num);
          final formattedBerat = '$berat Kg';
          final harga = (item['total_biaya'] as num);
          final formattedHarga = '$harga.000';
          final nomor = (item['nomor_pelanggan'] as String);
          final formattedNomor = '+62$nomor';
          final cucian = (item['status_cucian'] as String);
          final formattedCucian = cucian.capitalizeFirst;
          final statusPembayaran = item['status_pembayaran'] as String;
          final formattedStatusP =
              statusPembayaran == 'sudah_dibayar' ? 'Sudah Dibayar' : 'Belum Dibayar';

          if (item is Map<String, dynamic>) {
            return {
              'transaksi_id': item['transaksi_id'],
              'nama_pelanggan': item['nama_pelanggan'],
              // 'nomor_pelanggan': formattedNomor,
              // 'nama_karyawan_masuk': item['nama_karyawan_masuk'],
              // 'kategori_pelanggan': item['kategori_pelanggan'],
              // 'metode_laundry': item['metode_laundry'],
              // 'layanan_laundry': item['layanan_laundry'],
              // 'berat_laundry': formattedBerat,
              // 'status_pembayaran': formattedStatusP,
              // 'total_biaya': formattedHarga,
              // 'status_cucian': formattedCucian,
              'tanggal_datang': formattedDate,
            };
          } else {
            return <String, dynamic>{};
          }
        }).toList();

        // Update the totalDataCount variable
        totalDataCount.value = data.length;

        // Paginate the new data based on the specified page
        final startIdx = (page - 1) * 10;
        final endIdx = startIdx + 10;

        if (startIdx < data.length) {
          // Ensure that the start index is within the bounds of newData
          data.value = data.sublist(startIdx, endIdx.clamp(startIdx, data.length));
        } else {
          // Handle the case where startIdx is beyond the length of newData
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
    'transaksi_id': 'ID',
    'nama_pelanggan': 'Nama Pelanggan',
    'nomor_pelanggan': 'Nomor Pelanggan',
    'kategori_pelanggan': 'Kategori Pelanggan',
    'nama_karyawan_masuk': 'Nama Karyawan Penerima',
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
