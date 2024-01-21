import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DatapelangganController extends GetxController {
  RxBool isLoading = false.obs;
  SupabaseClient client = Supabase.instance.client;

  RxList<Map<String, dynamic>> data = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> filteredData = <Map<String, dynamic>>[].obs;

  // @override
  // void onInit() {
  //   fetchData();
  //   super.onInit();
  // }

  // @override
  // void onReady() {
  //   fetchData();
  //   super.onReady();
  // }

  Future<void> refreshData() async {
    isLoading.value = true;
    await fetchData();
    isLoading.value = false;
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      final response = await client
          .from('user')
          .select('*')
          .eq('role', 'Pelanggan')
          .order('id_user', ascending: true);

      isLoading.value = false;

      if (response != null && response is List) {
        // Convert each item in the list to a Map<String, dynamic>
        data.value = response.map((item) => item as Map<String, dynamic>).toList();
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
      data.where(
          (user) => user['nama'].toString().toLowerCase().contains(query.toLowerCase())),
    );
  }
}
