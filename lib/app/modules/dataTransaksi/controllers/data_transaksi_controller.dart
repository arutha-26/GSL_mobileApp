import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// TODO
/*
* BUATKAN FITUR UNTUK MENAMPILKAN DATA TRANSAKSI BERDASARKAN NAMA PELANGGAN DAN RENTANG TANGGAL, LALU FITUR UNTUK MENDOWNLOAD DATA YANG TAMPIL TERSEBUT KE PDF/CSV
* */

class DataTransaksiController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isHidden = true.obs;

  SupabaseClient client = Supabase.instance.client;

  RxList<Map<String, dynamic>> data = <Map<String, dynamic>>[].obs;
  RxInt currentPage = 1.obs;
  Rx<DateTime> selectedDate = Rx(DateTime.now());

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
          .lte('tanggal_datang',
          '${endDate.value.toLocal().add(const Duration(days: 1))}') // Add one day to include all data for the end date
          .execute(); // Fetch all data for the date range

      if (response != null && response.data != null && response.data is List) {
        data.value = (response.data as List).map((item) {
          if (item is Map<String, dynamic>) {
            return item;
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
