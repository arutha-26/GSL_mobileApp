import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DataTransaksiController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isHidden = true.obs;

  SupabaseClient client = Supabase.instance.client;

  RxList<Map<String, dynamic>> data = <Map<String, dynamic>>[].obs;
  RxInt currentPage = 1.obs;

  Future<void> fetchData({int page = 1}) async {
    try {
      isLoading.value = true; // Set loading to true
      final response = await client
          .from('transaksi')
          .select('*')
          .limit(10)
          .range((page - 1) * 10, page * 10 - 1) // Calculate range based on the page
          .execute();

      if (response != null && response.data != null && response.data is List) {
        // Safely cast each item in the list to Map<String, dynamic>
        data.value = (response.data as List).map((item) {
          if (item is Map<String, dynamic>) {
            return item;
          } else {
            // Handle cases where the item is not a Map<String, dynamic>
            return <String, dynamic>{};
          }
        }).toList();

        print('Fetched data: $data');
      } else {
        print('Error: Invalid data format');
      }
    } catch (error) {
      // Handle other exceptions
      print('Error: $error');
    } finally {
      isLoading.value = false; // Set loading to false after completion
    }
  }

  final Map<String, String> columnNames = {
    'transaksi_id': 'ID',
    'nama_pelanggan': 'Nama Pelanggan',
    'nomor_pelanggan': 'Nomor Pelanggan',
    'kategori_pelanggan': 'Kategori Pelanggan',
    'nama_karyawan': 'Nama Karyawan',
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
