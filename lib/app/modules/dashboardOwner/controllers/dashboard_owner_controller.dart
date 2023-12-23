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
        totalDebt.value = total;
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
        totalPaidDebt.value = total;
      } else if (kDebugMode) {
        print('Error fetching data: HTTP status ${response.status}');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Exception during fetching data: $error');
      }
    }
  }

  Future<void> fetchDataTodayTransactions() async {
    try {
      DateTime now = DateTime.now();
      String formattedDate =
          DateFormat('yyyy-MM-dd').format(now); // Format the date as 'yyyy-MM-dd'

      final response = await client
          .from('transaksi')
          .select('*')
          .gte('tanggal_datang', formattedDate)
          .lte('tanggal_datang', formattedDate)
          .execute();

      if (response.status == 200 && response.data != null && response.data is List) {
        // Set the count to the number of transactions
        todayTransactionCount.value = response.data.length;
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
        print('Monthly Transaction Data:');
        for (int day = 1; day <= lastDayOfMonth.day; day++) {
          print('Day $day: ${transactionsPerDay[day - 1]} transactions');
        }
      } else {
        print('Error fetching data: HTTP status ${response.status}');
      }
    } catch (error) {
      print('Exception during fetching data: $error');
    }
  }
}
