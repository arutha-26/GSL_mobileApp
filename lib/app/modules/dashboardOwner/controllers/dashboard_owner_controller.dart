import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardOwnerController extends GetxController {
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
    await fetchMonthlyTransactionData(DateTime.now());
    isLoading.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    fetchDataHutang();
    fetchDataCucian();
    fetchDataPaid();
    fetchDataTodayTransactions();
    fetchMonthlyTransactionData(DateTime.now());
  }

  Future<void> fetchDataCucian() async {
    try {
      final response =
          await client.from('transaksi').select('*').eq('status_cucian', 'diproses').execute();

      if (response.status == 200 && response.data != null && response.data is List) {
        count.value = response.data.length;
      }
    } catch (error) {
      print('Exception during fetching data: $error');
    }
  }

  final RxString formattedTotalDebt =
      ''.obs; // Variabel baru untuk menyimpan nilai format string

  Future<void> fetchDataHutang() async {
    try {
      final response = await client
          .from('transaksi')
          .select('*')
          .eq('status_pembayaran', 'belum_dibayar')
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
      final response = await client
          .from('transaksi')
          .select('*')
          .eq('status_pembayaran', 'sudah_dibayar')
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

  Future<void> fetchDataTodayTransactions() async {
    try {
      DateTime now = DateTime.now().toUtc();
      String startDate = "${DateFormat('yyyy-MM-dd').format(now)}T00:00:00";
      String endDate = "${DateFormat('yyyy-MM-dd').format(now)}T23:59:59";

      final response = await client
          .from('transaksi')
          .select('*')
          .gte('tanggal_datang', startDate)
          .lte('tanggal_datang', endDate)
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

  var selectedMonth = DateTime.now().obs; // Menambahkan variable untuk bulan terpilih

  // Modifikasi fungsi fetchMonthlyTransactionData untuk menerima parameter DateTime
  Future<void> fetchMonthlyTransactionData(DateTime month) async {
    try {
      // Define the first and last day of the selected month
      DateTime firstDayOfMonth = DateTime(month.year, month.month, 1);
      DateTime lastDayOfMonth = DateTime(month.year, month.month + 1, 0);

      // Fetch transactions for the selected month
      final response = await client
          .from('transaksi')
          .select('*')
          .gte('tanggal_datang', DateFormat('yyyy-MM-dd').format(firstDayOfMonth))
          .lte('tanggal_datang', DateFormat('yyyy-MM-dd').format(lastDayOfMonth))
          .order('tanggal_datang')
          .execute();

      if (response.status == 200 && response.data != null && response.data is List) {
        Map<int, int> dayCounts = {};
        for (var item in response.data) {
          DateTime date = DateTime.parse(item['tanggal_datang']);
          int dayIndex = date.difference(firstDayOfMonth).inDays;
          dayCounts.update(dayIndex, (value) => value + 1, ifAbsent: () => 1);
        }

        // Initialize transactionsPerDay with zeros for the entire month
        List<int> transactionsPerDay =
            List.generate(lastDayOfMonth.day, (index) => dayCounts[index] ?? 0);

        // Update the observable with the new data
        monthlyTransactionData.value = transactionsPerDay;

        // Debugging: Print the transaction data
        if (kDebugMode) {
          print('Monthly Transaction Data:');
        }
        for (int day = 1; day <= lastDayOfMonth.day; day++) {
          if (kDebugMode) {
            print('Day $day: ${transactionsPerDay[day - 1]} transactions');
          }
        }
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
}
