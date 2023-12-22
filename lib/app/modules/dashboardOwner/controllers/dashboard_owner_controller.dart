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
    await fetchMonthlyTransactionData();
    isLoading.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    fetchDataHutang();
    fetchDataCucian();
    fetchDataPaid();
    fetchDataTodayTransactions();
    fetchMonthlyTransactionData();
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

  Future<void> fetchMonthlyTransactionData() async {
    try {
      DateTime now = DateTime.now();
      String startOfMonth = DateFormat('yyyy-MM-01').format(now);

      DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
      DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

      final response = await client
          .from('transaksi')
          .select('*')
          .gte('tanggal_datang', startOfMonth)
          .order('tanggal_datang')
          .execute();

      if (response.status == 200 && response.data != null && response.data is List) {
        Map<int, int> dayCounts = {};
        for (var item in response.data) {
          DateTime date = DateTime.parse(item['tanggal_datang']);
          int dayIndex = date.difference(firstDayOfMonth).inDays;
          dayCounts.update(dayIndex, (value) => value + 1, ifAbsent: () => 1);
        }

        List<int> transactionsPerDay =
            List.generate(lastDayOfMonth.day, (index) => dayCounts[index] ?? 0);
        monthlyTransactionData.value = transactionsPerDay;

        print('Monthly Transaction Data:');
        for (int day = 1; day <= lastDayOfMonth.day; day++) {
          DateTime currentDay = firstDayOfMonth.add(Duration(days: day - 1));
          String dayName = DateFormat('EEEE').format(currentDay); // Mendapatkan nama hari
          print('Day $day ($dayName): ${transactionsPerDay[day - 1]} transactions');
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
}
