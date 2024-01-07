import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TransaksiHariIniController extends GetxController {
  SupabaseClient client = Supabase.instance.client;

  RxList<Map<String, dynamic>> data = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> filteredData = <Map<String, dynamic>>[].obs;

  void searchByName(String query) {
    if (query.isEmpty) {
      filteredData.assignAll(data);
      return;
    }

    filteredData.assignAll(
      data.where((user) =>
          user['nama_pelanggan'].toString().toLowerCase().contains(query.toLowerCase())),
    );
  }

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    refreshData();
    fetchData();
    super.onInit();
  }

  Future<void> refreshData() async {
    isLoading.value = true;
    await fetchData();
    isLoading.value = false;
  }

  final formattedNow = DateTime.now().toLocal(); // Adjust toLocal if needed

  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      final response = await client
          .from('transaksi')
          .select('*')
          .eq('tanggal_datang', DateTime.now().toString());
      isLoading.value = false;

      if (response != null && response is List) {
        data.value = response.map((item) => item as Map<String, dynamic>).toList();
        filteredData.value = List.from(data);
        if (kDebugMode) {
          print('Fetched data: $data');
        }
        update();
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
}
