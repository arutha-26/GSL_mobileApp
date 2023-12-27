import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PelangganStatusController extends GetxController {
  SupabaseClient client = Supabase.instance.client;

  RxBool isLoading = false.obs;

  Future<void> refreshData() async {
    isLoading.value = true;
    await getUserRole();
    fetchTransactionHistory();
    isLoading.value = false;
  }

  RxList<Map<String, dynamic>> originalTransactionHistory = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();

    // Observe changes in selectedStatus and update the dropdown value accordingly
    ever(selectedStatus, (_) {
      updateTransactionList();
    });

    getUserRole();
    fetchTransactionHistory();
  }

  RxString userRole = RxString('');

  Future<void> getUserRole() async {
    try {
      var uid = client.auth.currentUser?.id;

      if (uid == null) {
        if (kDebugMode) {
          print("User ID not found");
        }
        return;
      }

      var response =
          await client.from('user').select('role').eq('uid', uid).single().execute();

      if (response.data != null && response.data.isNotEmpty) {
        userRole.value = response.data['role'] as String? ?? '';
        if (kDebugMode) {
          print(response.data.toString());
        }
      } else {
        if (kDebugMode) {
          print("No user found");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Exception occurred: $e");
      }
    }
  }

  Future<String?> getCurrentUserName() async {
    try {
      final response = await client
          .from('user')
          .select('nama')
          .eq('uid', client.auth.currentUser?.id)
          .single()
          .execute();

      if (response.status == 200 && response.data != null) {
        return response.data['nama'] as String?;
      } else {
        if (kDebugMode) {
          print('Error fetching user data: HTTP status ${response.status}');
        }
        return null;
      }
    } catch (error) {
      if (kDebugMode) {
        print('Exception during fetching user data: $error');
      }
      return null;
    }
  }

  RxList<Map<String, dynamic>> transactionHistory = <Map<String, dynamic>>[].obs;

  Future<void> fetchTransactionHistory() async {
    isLoading.value = true;
    try {
      var namaPelanggan = await getCurrentUserName();

      final response = await client
          .from('transaksi')
          .select('*')
          .eq('nama_pelanggan', namaPelanggan)
          .order('transaksi_id', ascending: false)
          .execute();

      if (response.status == 200 && response.data != null) {
        // Cast the response data to a list of maps
        var dataList = List<Map<String, dynamic>>.from(response.data);

        transactionHistory.assignAll(dataList);
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

  final List<String> statusOptions = ['Diproses', 'Selesai', 'Diambil'];

  RxString selectedStatus = 'Diproses'.obs;

  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

  void filterByStatus(String? status) {
    selectedStatus.value = status ?? 'Diproses'; // Set a default value if status is null
    updateTransactionList();
  }

  void filterByDate(DateTimeRange dateRange) {
    selectedDate.value = dateRange.start;
    updateTransactionList();
  }

  void updateTransactionList() {
    var filteredList = List<Map<String, dynamic>>.from(originalTransactionHistory);

    if (selectedStatus.isNotEmpty) {
      filteredList = filteredList.where((transaksi) {
        bool condition =
            transaksi['status_cucian']?.toLowerCase() == selectedStatus.value.toLowerCase();
        if (kDebugMode) {
          print(
              'Status condition: $condition (status_cucian: ${transaksi['status_cucian']}, selectedStatus: ${selectedStatus.value})');
        }
        return condition;
      }).toList();
    }

    if (selectedDate.value != null) {
      filteredList = filteredList.where((transaksi) {
        bool condition = transaksi['tanggal_datang'] != null &&
            DateTime.parse(transaksi['tanggal_datang']).isAfter(selectedDate.value!);
        if (kDebugMode) {
          print(
              'Date condition: $condition (tanggal_datang: ${transaksi['tanggal_datang']}, selectedDate: ${selectedDate.value})');
        }
        return condition;
      }).toList();
    }

    transactionHistory.assignAll(filteredList);
  }
}
