import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../routes/app_pages.dart';
import '../../../utils/barChartSample3.dart';
import '../../../utils/bottom_navbar.dart';
import '../controllers/dashboard_owner_controller.dart';

class DashboardOwnerView extends GetView<DashboardOwnerController> {
  const DashboardOwnerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              controller.refreshData();
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.isTrue) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return SingleChildScrollView(
            child: Column(
              children: [
                Image.asset('images/banner_1.png'),
                _buildStatusAndDebtsCard(),
                _buildProfitAndTransactionCountCard(),
                const SizedBox(height: 10),
                const Text(
                  'Grafik Transaksi Bulanan',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                _buildMonthlyTransactionsGraph(),
                // _buildMonthlyIncomeGraph(),
              ],
            ),
          );
        }
      }),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          // Handle navigation using Get
          switch (index) {
            case 0:
              Get.offAllNamed(Routes.OWNERHOME); // Replace with your actual home route
              break;
            case 1:
              Get.offAllNamed(
                  Routes.DASHBOARD_OWNER); // Replace with your actual dashboard route
              break;
            case 2:
              Get.offAllNamed(Routes.OWNERPROFILE); // Replace with your actual profile route
              break;
            default:
          }
        },
      ),
    );
  }

  Widget buildRowCard(Widget card1, Widget card2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(child: card1),
        const SizedBox(width: 8),
        Expanded(child: card2),
      ],
    );
  }

  Widget _buildStatusAndDebtsCard() {
    return buildRowCard(
      _buildPaidDebtsCard(),
      _buildOutstandingDebtsCard(),
    );
  }

  Widget _buildProfitAndTransactionCountCard() {
    return buildRowCard(
      _buildStatusCard(),
      _buildTodayTransactionsCard(),
    );
  }

  Widget _buildStatusCard() {
    return InkWell(
      onTap: () {
        // Arahkan ke halaman yang diinginkan
        Get.toNamed(Routes.STATUS_CUCIAN_TRANSAKSI);
      },
      child: Card(
        child: ListTile(
          title: const Text('Status Cucian'),
          subtitle: Obx(() => Text('${controller.count.value} dalam proses')),
        ),
      ),
    );
  }

  Widget _buildOutstandingDebtsCard() {
    return InkWell(
      onTap: () {
        // Arahkan ke halaman yang diinginkan
        Get.offAllNamed(Routes.OWNERHOME);
      },
      child: Card(
        color: Colors.redAccent,
        child: ListTile(
          title: const Text('Transaksi\nBelum Lunas'),
          subtitle: Obx(() => Text('Rp${controller.formattedTotalDebt.value}')),
        ),
      ),
    );
  }

  Widget _buildPaidDebtsCard() {
    return InkWell(
      onTap: () {
        // Arahkan ke halaman yang diinginkan
        Get.offAllNamed(Routes.OWNERHOME);
      },
      child: Card(
        color: Colors.greenAccent,
        child: ListTile(
          title: const Text('Transaksi\nLunas'),
          subtitle: Obx(() => Text('Rp${controller.formattedTotalPaid.value}')),
        ),
      ),
    );
  }

  Widget _buildTodayTransactionsCard() {
    return InkWell(
      onTap: () {
        // Arahkan ke halaman yang diinginkan
        Get.toNamed(Routes.TRANSAKSI_HARI_INI);
      },
      child: Card(
        child: ListTile(
          title: const Text('Transaksi Hari Ini'),
          subtitle: Obx(() => Text('${controller.todayTransactionCount.value} transaksi')),
        ),
      ),
    );
  }

  Widget _buildMonthlyTransactionsGraph() {
    return Column(
      children: [
        monthSelectionDropdown(),
        Obx(() {
          if (controller.isLoading.value) {
            // Tampilkan indikator loading saat data sedang dimuat
            return const Center(child: CircularProgressIndicator());
          }

          final transactionsData = controller.monthlyTransactionData.value;

          if (transactionsData.isNotEmpty) {
            // Use the selected month and year
            DateTime selectedMonth = controller.selectedMonth.value ?? DateTime.now();
            DateTime firstDayOfSelectedMonth =
                DateTime(selectedMonth.year, selectedMonth.month, 1);

            List<String> dates = List.generate(transactionsData.length, (index) {
              DateTime date = firstDayOfSelectedMonth.add(Duration(days: index));
              return DateFormat('dd').format(date); // Format as 'Day-Month'
            });

            return SizedBox(
              height: 250,
              child: BarChartSample3(
                transactionsPerDay: transactionsData,
                dates: dates,
              ),
            );
          } else {
            return const Center(child: Text('Tidak ada data transaksi untuk ditampilkan.'));
          }
        }),
      ],
    );
  }

  Widget monthSelectionDropdown() {
    DateTime initialMonth = controller.selectedMonth.value;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DropdownButton<int>(
          value: initialMonth.month,
          onChanged: (int? newValue) {
            if (newValue != null) {
              controller.selectedMonth.value = DateTime(initialMonth.year, newValue);
              controller.fetchMonthlyTransactionData(
                  controller.selectedMonth.value.year, controller.selectedMonth.value.month);
            }
          },
          items: List.generate(12, (index) {
            return DropdownMenuItem<int>(
              value: index + 1,
              child: Text(DateFormat('MMMM').format(DateTime(initialMonth.year, index + 1))),
            );
          }),
        ),
        const SizedBox(width: 16), // Menambahk
        DropdownButton<int>(
          value: initialMonth.year,
          onChanged: (int? newValue) {
            if (newValue != null) {
              controller.selectedMonth.value = DateTime(newValue, initialMonth.month);
              controller.fetchMonthlyTransactionData(
                  controller.selectedMonth.value.year, controller.selectedMonth.value.month);
            }
          },
          items: List.generate(5, (index) {
            int year = DateTime.now().year - index;
            return DropdownMenuItem<int>(
              value: year,
              child: Text(year.toString()),
            );
          }),
        ),
      ],
    );
  }
}
