import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// TODO
/*
REBUILT DATABASE
SELESAIKAN INI
BUATKAN HISTORY NYA CARD WIDTH SESUAI LAYAR
JOIN TABLE USER DAN TRANSAKSI
*/

class PelangganhomeController extends GetxController {
  SupabaseClient client = Supabase.instance.client;

  RxBool isLoading = false.obs;

  final count = 0.obs;
  final RxDouble totalDebt = 0.0.obs;
  final RxDouble totalPaidDebt = 0.0.obs;
  var todayTransactionCount = 0.obs;
  var monthlyTransactionData = <int>[].obs;

  Future<void> refreshData() async {
    isLoading.value = true;
    await fetchDataHutang();
    await fetchDataCucian();
    await fetchDataPaid();
    await fetchDataTodayTransactions();
    await getUserRole();
    isLoading.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    fetchDataHutang();
    fetchDataCucian();
    fetchDataPaid();
    fetchDataTodayTransactions();
    getUserRole();
  }

  Future<void> fetchDataCucian() async {
    try {
      var namaPelanggan = await getCurrentUserName();

      final response = await client
          .from('transaksi')
          .select('*')
          .eq('status_cucian', 'diproses')
          .eq('nama_pelanggan', namaPelanggan)
          .execute();

      if (response.status == 200 && response.data != null && response.data is List) {
        count.value = response.data.length;
      }
    } catch (error) {
      print('Exception during fetching data: $error');
    }
  }

  final RxString formattedTotalDebt =
      ''.obs; // Variabel baru untuk menyimpan nilai format string
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

  Future<void> fetchDataHutang() async {
    try {
      var namaPelanggan = await getCurrentUserName();

      if (namaPelanggan != null) {
        final response = await client
            .from('transaksi')
            .select('*')
            .eq('status_pembayaran', 'belum_dibayar')
            .eq('nama_pelanggan', namaPelanggan)
            .execute();

        if (response.status == 200 && response.data != null && response.data is List) {
          double total = 0.0;
          for (var item in response.data) {
            if (item['total_biaya'] != null) {
              total += double.tryParse(item['total_biaya'].toString()) ?? 0.0;
            }
          }

          totalDebt.value = total; // Simpan nilai numerik

          // Format total biaya menjadi format uang dan simpan di formattedTotalDebt
          final formatter = NumberFormat('#,##0.000', 'id_ID');
          formattedTotalDebt.value = formatter.format(total);
        } else {
          if (kDebugMode) {
            print('Error fetching data: HTTP status ${response.status}');
          }
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Exception during fetching data: $error');
      }
    }
  }

  Future<void> fetchDataTodayTransactions() async {
    try {
      var namaPelanggan = await getCurrentUserName();

      DateTime now = DateTime.now().toUtc();
      String startDate = "${DateFormat('yyyy-MM-dd').format(now)}T00:00:00";
      String endDate = "${DateFormat('yyyy-MM-dd').format(now)}T23:59:59";

      final response = await client
          .from('transaksi')
          .select('*')
          .gte('tanggal_datang', startDate)
          .lte('tanggal_datang', endDate)
          .eq('nama_pelanggan', namaPelanggan)
          .execute();

      if (response.status == 200 && response.data != null && response.data is List) {
        // Log the data for inspection
        if (kDebugMode) {
          print('Received data: ${response.data}');
        }

        // Additional check for data format
        if (response.data.every((item) => item is Map<String, dynamic>)) {
          todayTransactionCount.value = response.data.length;
        } else if (kDebugMode) {
          print('Data format is not as expected');
        }
      } else if (kDebugMode) {
        print('Error fetching data: HTTP status ${response.status}');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Exception during fetching data: $error');
      }
    }
  }

  final RxString formattedTotalPaid =
      ''.obs; // Variabel baru untuk menyimpan nilai format string
  Future<void> fetchDataPaid() async {
    try {
      var namaPelanggan = await getCurrentUserName();

      final response = await client
          .from('transaksi')
          .select('*')
          .eq('status_pembayaran', 'sudah_dibayar')
          .eq('nama_pelanggan', namaPelanggan)
          .execute();

      if (response.status == 200 && response.data != null && response.data is List) {
        double total = 0.0;
        for (var item in response.data) {
          if (item['total_biaya'] != null) {
            total += double.tryParse(item['total_biaya'].toString()) ?? 0.0;
          }
        }

        totalPaidDebt.value = total; // Simpan nilai numerik

        // Format total biaya menjadi format uang dan simpan di formattedTotalDebt
        final formatter = NumberFormat('#,##0.000', 'id_ID');
        formattedTotalPaid.value = formatter.format(total);
      } else {
        if (kDebugMode) {
          print('Error fetching data: HTTP status ${response.status}');
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Exception during fetching data: $error');
      }
    }
  }

  RxString userRole = RxString('');
  RxInt selectedIndexOwner = 0.obs;
  RxInt selectedIndexKaryawan = 0.obs;
  RxInt selectedIndexPelanggan = 0.obs;

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
}
