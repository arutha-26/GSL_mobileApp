import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PelangganTransaksiController extends GetxController {
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
          .select(
              'id_transaksi, tanggal_datang, total_biaya, berat_laundry, status_cucian, status_pembayaran, layanan_laundry, metode_laundry, metode_pembayaran, tanggal_selesai, tanggal_diambil, id_karyawan_masuk, id_karyawan_keluar, is_hidden, edit_at, id_user(id_user, nama, no_telp, kategori, alamat)')
          .eq('id_user.nama', namaPelanggan)
          .neq('status_cucian', 'Diambil')
          .order('id_transaksi', ascending: false)
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

  Rx<DateTime?> selectedStartDate = Rx<DateTime?>(null);
  Rx<DateTime?> selectedEndDate = Rx<DateTime?>(null);

  final List<String> statusOptions = ['Dalam Proses', 'Selesai'];

  RxString selectedStatus = 'Dalam Proses'.obs;

  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

  void filterByStatus(String? status) {
    selectedStatus.value = status ?? 'Dalam Proses'; // Set a default value if status is null
    updateTransactionList();
  }

  void filterByDate(DateTimeRange dateRange) {
    selectedStartDate.value = dateRange.start;
    selectedEndDate.value = dateRange.end;
    updateTransactionList();
  }

  void updateTransactionList() {
    var filteredList = List<Map<String, dynamic>>.from(originalTransactionHistory);

    if (selectedStatus.isNotEmpty) {
      filteredList = filteredList.where((transaksi) {
        bool condition = transaksi['status_cucian'] == selectedStatus.value;
        if (kDebugMode) {
          print(
              'Status condition: $condition (status_cucian: ${transaksi['status_cucian']}, selectedStatus: ${selectedStatus.value})');
        }
        return condition;
      }).toList();
    }

    if (selectedStartDate.value != null && selectedEndDate.value != null) {
      filteredList = filteredList.where((transaksi) {
        DateTime transactionDate = DateTime.parse(transaksi['tanggal_datang']);
        DateTime start = selectedStartDate.value!;
        DateTime end = selectedEndDate.value!.add(const Duration(days: 1));

        print('Transaction Date: $transactionDate');
        print('Selected Start Date: $start');
        print('Selected End Date: $end');

        bool dateCondition = transactionDate.isAfter(start) && transactionDate.isBefore(end);
        print('Date condition: $dateCondition');

        return dateCondition;
      }).toList();
    }

    transactionHistory.assignAll(filteredList);
  }
}
