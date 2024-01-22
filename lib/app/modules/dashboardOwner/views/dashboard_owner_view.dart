import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glassmorphism/glassmorphism.dart';
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
      body: FutureBuilder(
          future: controller.refreshData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
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
                  BarWidget(controller: controller)

                  // _buildMonthlyIncomeGraph(),
                ],
              ),
            );
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
        // Menggunakan BoxDecoration dengan gradient sebagai latar belakang
        color: Colors.white,
        // Gunakan warna transparan karena LinearGradient akan menangani latar belakang
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5.0,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0x000891b2).withOpacity(0.1),
                const Color(0x004ade80).withOpacity(0.4),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ListTile(
            title: const Text('Status Cucian'),
            subtitle: Obx(() => Text('${controller.count.value} dalam proses')),
          ),
        ),
      ),
    );
  }

  Widget _buildOutstandingDebtsCard() {
    return InkWell(
      // onTap: () {
      //   // Arahkan ke halaman yang diinginkan
      //   Get.offAllNamed(Routes.OWNERHOME);
      // },
      child: Card(
        // Menggunakan BoxDecoration dengan gradient sebagai latar belakang
        color: Colors.white,
        // Gunakan warna transparan karena LinearGradient akan menangani latar belakang
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5.0,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0x000891b2).withOpacity(0.1),
                const Color(0x004ade80).withOpacity(0.4),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ListTile(
            title: const Text('Transaksi\nBelum Lunas'),
            subtitle: Obx(() => Text('Rp${controller.formattedTotalDebt.value}')),
          ),
        ),
      ),
    );
  }

  Widget _buildPaidDebtsCard() {
    return InkWell(
      // onTap: () {
      //   // Arahkan ke halaman yang diinginkan
      //   Get.offAllNamed(Routes.OWNERHOME);
      // },
      child: Card(
        // Menggunakan BoxDecoration dengan gradient sebagai latar belakang
        color: Colors.white,
        // Gunakan warna transparan karena LinearGradient akan menangani latar belakang
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5.0,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0x000891b2).withOpacity(0.1),
                const Color(0x004ade80).withOpacity(0.4),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ListTile(
            title: const Text('Transaksi\nLunas'),
            subtitle: Obx(() => Text('Rp${controller.formattedTotalPaid.value}')),
          ),
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
        // Menggunakan BoxDecoration dengan gradient sebagai latar belakang
        color: Colors.white,
        // Gunakan warna transparan karena LinearGradient akan menangani latar belakang
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5.0,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0x000891b2).withOpacity(0.1),
                const Color(0x004ade80).withOpacity(0.4),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ListTile(
            title: const Text('Transaksi Hari Ini'),
            subtitle: Obx(() => Text('${controller.todayTransactionCount.value} transaksi')),
          ),
        ),
      ),
    );
  }
}

class BarWidget extends StatefulWidget {
  final DashboardOwnerController controller;

  BarWidget({required this.controller});

  @override
  _BarWidgetState createState() => _BarWidgetState();
}

class _BarWidgetState extends State<BarWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildMonthlyTransactionsGraph(),
      ],
    );
  }

  Widget _buildMonthlyTransactionsGraph() {
    return Column(
      children: [
        monthSelectionDropdown(),
        Obx(() {
          if (widget.controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final transactionsData = widget.controller.monthlyTransactionData.value;

          if (transactionsData.isNotEmpty) {
            DateTime selectedMonth = widget.controller.selectedMonth.value;
            DateTime firstDayOfSelectedMonth =
                DateTime(selectedMonth.year, selectedMonth.month, 1);

            List<String> dates = List.generate(transactionsData.length, (index) {
              DateTime date = firstDayOfSelectedMonth.add(Duration(days: index));
              return DateFormat('dd').format(date);
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
    DateTime initialMonth = widget.controller.selectedMonth.value;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DropdownButton<int>(
          value: widget.controller.selectedMonth.value.month,
          onChanged: (int? newValue) {
            if (newValue != null) {
              widget.controller.selectedMonth.value = DateTime(initialMonth.year, newValue);
              widget.controller.fetchMonthlyTransactionData(
                widget.controller.selectedMonth.value.year,
                widget.controller.selectedMonth.value.month,
              );
              setState(() {});
            }
          },
          items: List.generate(12, (index) {
            return DropdownMenuItem<int>(
              value: index + 1,
              child: Text(DateFormat('MMMM').format(DateTime(initialMonth.year, index + 1))),
            );
          }),
        ),
        const SizedBox(width: 16),
        DropdownButton<int>(
          value: widget.controller.selectedMonth.value.year,
          onChanged: (int? newValue) {
            if (newValue != null) {
              widget.controller.selectedMonth.value = DateTime(newValue, initialMonth.month);
              widget.controller.fetchMonthlyTransactionData(
                widget.controller.selectedMonth.value.year,
                widget.controller.selectedMonth.value.month,
              );
              setState(() {});
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

class GlassButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final Color color;
  final String iconPath;

  GlassButton({
    required this.onPressed,
    required this.label,
    required this.color,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: double.infinity,
      borderRadius: 10,
      blur: 10,
      alignment: Alignment.center,
      border: 2,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0x000891b2).withOpacity(0.1),
          const Color(0x004ade80).withOpacity(0.4),
        ],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.greenAccent.withOpacity(0.1),
          Colors.black12.withOpacity(0.4),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconPath,
              height: 30,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
