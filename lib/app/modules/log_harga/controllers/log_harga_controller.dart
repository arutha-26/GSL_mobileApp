import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LogHargaController extends GetxController {
  @override
  void onInit() {
    super.onInit();

    // Observe changes in selectedStatus and update the dropdown value accordingly
    ever(selectedStatus, (_) {
      updateTransactionList();
    });
    fetchData();

    // getUserRole();
    // fetchTransactionHistory();
  }

  RxBool isLoading = false.obs;
  SupabaseClient client = Supabase.instance.client;
  Rx<DateTime?> selectedStartDate = Rx<DateTime?>(null);
  Rx<DateTime?> selectedEndDate = Rx<DateTime?>(null);

  final List<String> layananOptions = ['Cuci Setrika', 'Setrika Saja', 'Cuci Saja'];

  RxString selectedStatus = 'Cuci Setrika'.obs;

  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

  void filterByStatus(String? status) {
    selectedStatus.value = status ?? 'Cuci Setrika';
    updateTransactionList();
  }

  void filterByDate(DateTimeRange dateRange) {
    selectedStartDate.value = dateRange.start;
    selectedEndDate.value = dateRange.end;
    updateTransactionList();
  }

  RxList<Map<String, dynamic>> data = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> filteredData = <Map<String, dynamic>>[].obs;

  Future<void> fetchData() async {
    isLoading.value = true;
    try {
      final response = await client
          .from('log_harga')
          .select(
              'id_log, harga_kilo_lama, harga_kilo_baru, created_at, id_harga!inner(id_harga, kategori_pelanggan, metode_laundry_id, layanan_laundry_id, id_user)')
          // .eq('id_user.nama', namaPelanggan)
          // .neq('status_cucian', 'Diambil')
          .order('id_log', ascending: false)
          .execute();

      if (response.status == 200 && response.data != null) {
        // Cast the response data to a list of maps
        var dataList = List<Map<String, dynamic>>.from(response.data);

        filteredData.assignAll(dataList);
        originalTransactionHistory.assignAll(dataList); // Save the original data
      } else {
        if (kDebugMode) {
          print('Error fetching transaction history: HTTP status ${response.status}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception during fetching transaction history: $e');
      }
    } finally {
      isLoading.value = false;
    }
  }

  RxList<Map<String, dynamic>> originalTransactionHistory = <Map<String, dynamic>>[].obs;

  void updateTransactionList() {
    var filteredList = List<Map<String, dynamic>>.from(originalTransactionHistory);

    if (selectedStatus.isNotEmpty) {
      filteredList = filteredList.where((logHarga) {
        bool condition = logHarga['id_harga']['layanan_laundry_id'] == selectedStatus.value;
        if (kDebugMode) {
          print(
              'layanan : $condition (layanan: ${logHarga['id_harga']['layanan_laundry_id']}, layanan dipilih: ${selectedStatus.value})');
        }
        return condition;
      }).toList();
    }

    if (selectedStartDate.value != null && selectedEndDate.value != null) {
      filteredList = filteredList.where((logHarga) {
        DateTime transactionDate = DateTime.parse(logHarga['created_at']);
        DateTime start = selectedStartDate.value!;
        DateTime end = selectedEndDate.value!.add(const Duration(days: 1));

        if (kDebugMode) {
          print('tanggal diubah: $transactionDate');
        }
        if (kDebugMode) {
          print('Selected Start Date: $start');
        }
        if (kDebugMode) {
          print('Selected End Date: $end');
        }

        bool dateCondition = transactionDate.isAfter(start) && transactionDate.isBefore(end);
        if (kDebugMode) {
          print('Date edit: $dateCondition');
        }

        return dateCondition;
      }).toList();
    }

    filteredData.assignAll(filteredList);
  }
}
