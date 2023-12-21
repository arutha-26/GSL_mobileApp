import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PaneltransaksiController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isHidden = true.obs;

  SupabaseClient client = Supabase.instance.client;

  RxList<Map<String, dynamic>> data = <Map<String, dynamic>>[].obs;

  Future<void> fetchData() async {
    try {
      final response = await client.from('harga').select('id, kategori_pelanggan, metode_laundry_id, layanan_laundry_id, harga_kilo_regular, harga_kilo_express');

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
    'id': 'ID',
    'kategori_pelanggan': 'Kategori Pelanggan',
    'metode_laundry_id': 'Metode Laundry',
    'layanan_laundry_id': 'Layanan Laundry',
    'harga_kilo_regular': 'Harga Kilo Regular',
    'harga_kilo_express': 'Harga Kilo Express',
  };

}