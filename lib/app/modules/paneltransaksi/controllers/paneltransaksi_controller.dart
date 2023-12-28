import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PaneltransaksiController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isHidden = true.obs;

  SupabaseClient client = Supabase.instance.client;

  RxList<Map<String, dynamic>> data = <Map<String, dynamic>>[].obs;

  Future<void> fetchData() async {
    try {
      final response = await client.from('harga').select(
          'id, kategori_pelanggan, metode_laundry_id, layanan_laundry_id, harga_kilo, edit_at');

      if (response != null && response is List) {
        // Convert each item in the list to a Map<String, dynamic>
        data.value = response.map((item) {
          // Convert tanggal from 'yyyy-MM-dd' to 'dd-MM-yyyy'
          final editAt = DateTime.parse(item['edit_at'] as String);
          final formattedDate = '${editAt.day}-${editAt.month}-${editAt.year}';

          return {
            'id': item['id'],
            'kategori_pelanggan': item['kategori_pelanggan'],
            'metode_laundry_id': item['metode_laundry_id'],
            'layanan_laundry_id': item['layanan_laundry_id'],
            'harga_kilo': item['harga_kilo'],
            'edit_at': formattedDate,
          };
        }).toList();

        // Sort data berdasarkan ID terkecil
        data.sort((a, b) => a['id'].compareTo(b['id']));

        if (kDebugMode) {
          print('Fetched data: $data');
        }
      } else {
        if (kDebugMode) {
          print('Error: Invalid data format');
        }
      }
    } catch (error) {
      // Handle other exceptions
      if (kDebugMode) {
        print('Error: $error');
      }
    }
  }

  final Map<String, String> columnNames = {
    'id': 'ID',
    'kategori_pelanggan': 'Kategori Pelanggan',
    'metode_laundry_id': 'Metode Laundry',
    'layanan_laundry_id': 'Layanan Laundry',
    'harga_kilo': 'Harga Kilo',
    'edit_at': 'Terakhir Update',
  };
}
