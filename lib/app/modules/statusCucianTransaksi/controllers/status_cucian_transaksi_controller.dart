import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StatusCucianTransaksiController extends GetxController {
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
          user['id_user']['nama'].toString().toLowerCase().contains(query.toLowerCase())),
    );
  }

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    refreshData();
    fetchData();
    ever(filteredData, (_) {
      // Update the number of data whenever filteredData changes
      numberOfData.value = filteredData.length;
    });
    super.onInit();
  }

  Future<void> refreshData() async {
    isLoading.value = true;
    await fetchData();
    isLoading.value = false;
  }

  RxInt numberOfData = 0.obs;

  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      final response = await client
          .from('transaksi')
          .select(
              'id_transaksi, tanggal_datang, total_biaya, berat_laundry, status_cucian, status_pembayaran, layanan_laundry, metode_laundry, metode_pembayaran, kembalian, nominal_bayar, tanggal_selesai, tanggal_diambil, id_karyawan_masuk, id_karyawan_keluar, is_hidden, edit_at, id_user(id_user, nama, no_telp, kategori, alamat)')
          .eq('status_cucian', 'diproses');
      isLoading.value = false;

      if (response != null && response is List) {
        data.value = response.map((item) => item as Map<String, dynamic>).toList();
        filteredData.value = List.from(data);
        numberOfData.value = List.from(data).length; // Store the length
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
