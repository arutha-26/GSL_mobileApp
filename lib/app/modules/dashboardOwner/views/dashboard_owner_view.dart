import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../utils/barChartSample3.dart';
import '../../../utils/bottom_navbar.dart';
import '../controllers/dashboard_owner_controller.dart';

class DashboardOwnerView extends GetView<DashboardOwnerController> {
  const DashboardOwnerView({Key? key}) : super(key: key);

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
                _buildStatusAndDebtsCard(),
                _buildProfitAndTransactionCountCard(),
                _buildMonthlyTransactionsGraph(),
                _buildMonthlyIncomeGraph(),
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
        const SizedBox(width: 8), // Adding some space between the cards
        Expanded(child: card2),
      ],
    );
  }

  Widget _buildStatusAndDebtsCard() {
    return buildRowCard(
      _buildStatusCard(),
      _buildOutstandingDebtsCard(),
    );
  }

  Widget _buildProfitAndTransactionCountCard() {
    return buildRowCard(
      _buildPaidDebtsCard(),
      _buildTodayTransactionsCard(),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      child: ListTile(
        title: const Text('Status Cucian'),
        subtitle: Obx(() => Text('${controller.count.value} dalam proses')),
      ),
    );
  }

  Widget _buildOutstandingDebtsCard() {
    return Card(
      color: Colors.redAccent,
      child: ListTile(
        title: const Text('Hutang Belum Dibayar'),
        subtitle: Obx(() => Text('Rp${controller.totalDebt.value.toStringAsFixed(3)}')),
      ),
    );
  }

  Widget _buildPaidDebtsCard() {
    return Card(
      color: Colors.green,
      child: ListTile(
        title: const Text('Total Transaksi Sudah Dibayar'),
        subtitle: Obx(() => Text('Rp${controller.totalPaidDebt.value.toStringAsFixed(3)}')),
      ),
    );
  }

  Widget _buildTodayTransactionsCard() {
    return Card(
      child: ListTile(
        title: const Text('Transaksi Hari Ini'),
        subtitle: Obx(() => Text('${controller.todayTransactionCount.value} transaksi')),
      ),
    );
  }

  Widget _buildMonthlyTransactionsGraph() {
    return Obx(() {
      final transactionsData = controller.monthlyTransactionData.value;

      // Check if the data is available and not empty
      if (transactionsData != null && transactionsData.isNotEmpty) {
        return Container(
          height: 200,
          child: BarChartSample3(transactionsPerDay: transactionsData),
        );
      } else {
        // You can display a loading indicator or an empty state here
        return CircularProgressIndicator(); // Example loading indicator
      }
    });
  }

  Widget _buildMonthlyIncomeGraph() {
    return Container(
      height: 200,
      color: Colors.green,
      child: const Center(child: Text('Grafik Pendapatan Bulanan')),
    );
  }
}
