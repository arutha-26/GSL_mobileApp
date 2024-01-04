import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PaneltransaksiController extends GetxController {
  RxBool isLoading = false.obs;
  SupabaseClient client = Supabase.instance.client;

  RxList<Map<String, dynamic>> data = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> filteredData = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  Future<void> refreshData() async {
    isLoading.value = true;
    await fetchData();
    isLoading.value = false;
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      final response = await client.from('harga').select('*');
      isLoading.value = false;

      if (response != null && response is List) {
        // Convert each item in the list to a Map<String, dynamic>
        data.value = response.map((item) => item as Map<String, dynamic>).toList();

        // Sort data based on 'id' in ascending order
        data.value.sort((a, b) => a['id'].compareTo(b['id']));

        filteredData.value = List.from(data);
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

  void searchByName(String query) {
    if (query.isEmpty) {
      filteredData.assignAll(data);
      return;
    }

    filteredData.assignAll(
      data.where((user) =>
          user['metode_laundry_id'].toString().toLowerCase().contains(query.toLowerCase())),
    );
  }
}
