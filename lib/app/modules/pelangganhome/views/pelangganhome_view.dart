import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controllers.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/bottom_navbar.dart';
import '../controllers/pelangganhome_controller.dart';

class PelangganhomeView extends GetView<PelangganhomeController> {
  PelangganhomeView({Key? key}) : super(key: key);

  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Pelanggan'),
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
              ],
            ),
          );
        }
      }),
      bottomNavigationBar: Obx(() {
        String? userRole = controller.userRole.value;

        if (userRole != null) {
          switch (userRole) {
            case 'Owner':
              return BottomNavBar(
                currentIndex: _getCurrentIndex(userRole),
                onTap: (index) {
                  _handleNavigationOwner(index);
                },
              );
            case 'Karyawan':
              return BottomNavBar(
                currentIndex: _getCurrentIndex(userRole),
                onTap: (index) {
                  _handleNavigationKaryawan(index);
                },
              );
            case 'Pelanggan':
              return BottomNavBar(
                currentIndex: _getCurrentIndex(userRole),
                onTap: (index) {
                  _handleNavigationPelanggan(index);
                },
              );
            default:
              return Text("Unknown user role");
          }
        } else {
          // Jika gagal mendapatkan peran pengguna, tampilkan widget alternatif atau pesan kesalahan
          return Text("Failed to fetch user role");
        }
      }),
    );
  }

  int _getCurrentIndex(String userRole) {
    switch (userRole) {
      case 'Owner':
        return 0;
      case 'Karyawan':
        return 1;
      case 'Pelanggan':
        return 2;
      default:
        return 0;
    }
  }

  void _handleNavigationOwner(int index) {
    switch (index) {
      case 0:
        Get.offAllNamed(Routes.OWNERHOME);
        break;
      case 1:
        Get.offAllNamed(Routes.DASHBOARD_OWNER);
        break;
      case 2:
        Get.offAllNamed(Routes.OWNERPROFILE);
        break;
      default:
    }
  }

  void _handleNavigationKaryawan(int index) {
    // Handle navigation for Karyawan role
    // ...
  }

  void _handleNavigationPelanggan(int index) {
    switch (index) {
      case 0:
        Get.offAllNamed(Routes.PELANGGANHOME);
        break;
      case 1:
        Get.offAllNamed(Routes.PELANGGANHOME);
        break;
      case 2:
        Get.offAllNamed(Routes.PELANGGAN_PROFILE);
        break;
      default:
    }
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
        Get.offAllNamed(Routes.OWNERHOME);
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
        Get.offAllNamed(Routes.OWNERHOME);
      },
      child: Card(
        color: Colors.redAccent,
        child: ListTile(
          title: const Text('Hutang Belum Dibayar'),
          subtitle: Obx(() => Text('Rp. ${controller.formattedTotalDebt.value}')),
        ),
      ),
    );
  }

  Widget _buildPaidDebtsCard() {
    return InkWell(
      onTap: () {
        Get.offAllNamed(Routes.OWNERHOME);
      },
      child: Card(
        color: Colors.green,
        child: ListTile(
          title: const Text('Total Transaksi Sudah Dibayar'),
          subtitle: Obx(() => Text('Rp. ${controller.formattedTotalPaid.value}')),
        ),
      ),
    );
  }

  Widget _buildTodayTransactionsCard() {
    return InkWell(
      onTap: () {
        Get.offAllNamed(Routes.OWNERHOME);
      },
      child: Card(
        child: ListTile(
          title: const Text('Transaksi Hari Ini'),
          subtitle: Obx(() => Text('${controller.todayTransactionCount.value} transaksi')),
        ),
      ),
    );
  }
}
