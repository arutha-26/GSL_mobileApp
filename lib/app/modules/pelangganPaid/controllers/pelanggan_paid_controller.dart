import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PelangganPaidController extends GetxController {
  SupabaseClient client = Supabase.instance.client;

  RxBool isLoading = false.obs;

  Future<void> refreshData() async {
    isLoading.value = true;
    await getUserRole();
    fetchTransactionHistory();
    isLoading.value = false;
  }

  @override
  void onInit() {
    super.onInit();
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
          .eq('status_pembayaran', 'sudah_dibayar')
          .order('transaksi_id',
              ascending: false) // Urutkan berdasarkan tanggal_diambil secara menurun
          .execute();

      if (response.status == 200 && response.data != null) {
        // Cast the response data to a list of maps
        var dataList = List<Map<String, dynamic>>.from(response.data);

        // Modify the STATUS_PEMBAYARAN here
        // for (var transaction in dataList) {
        //   transaction['status_pembayaran'] = 'Belum dibayar';
        // }

        transactionHistory.assignAll(dataList);
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
}
