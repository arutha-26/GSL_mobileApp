import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../routes/app_pages.dart';

class DatapelangganController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isHidden = true.obs;

  SupabaseClient client = Supabase.instance.client;

  RxList<Map<String, dynamic>> data = <Map<String, dynamic>>[].obs;

  Future<void> fetchData() async {
    try {
      final response = await client.from('user').select('nama, kategori').eq('role', 'Pelanggan');

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



}

