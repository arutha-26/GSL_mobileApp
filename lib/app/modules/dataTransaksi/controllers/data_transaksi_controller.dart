import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DataTransaksiController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isHidden = true.obs;

  SupabaseClient client = Supabase.instance.client;

  RxList<Map<String, dynamic>> data = <Map<String, dynamic>>[].obs;

  Future<void> fetchData() async {
    try {
      final response = await client.from('transaksi').select('*');

      if (response != null && response is List) {
        // Convert each item in the list to a Map<String, dynamic>
        data.value = response.map((item) => item as Map<String, dynamic>).toList();
        print('Fetched data: $data');
      } else {
        print('Error: Invalid data format');
      }
    } catch (error) {
      // Handle other exceptions
      print('Error: $error');
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
