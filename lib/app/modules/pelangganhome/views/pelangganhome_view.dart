import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controllers.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/bottom_navbar.dart';
import '../controllers/pelangganhome_controller.dart';

class PelangganhomeView extends GetView<PelangganhomeController> {
  PelangganhomeView({super.key});

  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Green Spirit Laundry'),
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
        future: controller.getUserNama(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0), // Menambahkan padding di sekitar teks
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Green Spirit Laundry',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10), // Menambahkan spasi vertikal
                        Text(
                          'Tempat kebersihan tanpa kompromi. Percayakan cucian Anda kepada kami.',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                Image.asset('images/banner_1.png'),
                const SizedBox(height: 20),
                Text(
                  'Hallo Kakak ${controller.namaUser.text}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                _buildStatusAndDebtsCard(),
                const SizedBox(height: 10),
                _buildProfitAndTransactionCountCard(),
                const SizedBox(height: 10),
                CarouselSlider(
                  items: [
                    Image.asset('images/banner_11.png'),
                    Image.asset('images/banner_8.png'),
                    Image.asset('images/banner_12.png'),
                    Image.asset('images/banner_9.png'),
                    Image.asset('images/banner_10.png'),
                  ],
                  options: CarouselOptions(
                    autoPlay: true,
                    aspectRatio: 16 / 9,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: true,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    autoPlayAnimationDuration: const Duration(milliseconds: 2000),
                    viewportFraction: 1,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Obx(() {
        String? userRole = controller.userRole.value;

        if (userRole != null) {
          switch (userRole) {
            case 'Owner':
              return BottomNavBar(
                currentIndex: 0,
                onTap: (index) {
                  _handleNavigationOwner(index);
                },
              );
            case 'Karyawan':
              return BottomNavBar(
                currentIndex: 0,
                onTap: (index) {
                  _handleNavigationKaryawan(index);
                },
              );
            case 'Pelanggan':
              return BottomNavBar(
                currentIndex: 0,
                onTap: (index) {
                  _handleNavigationPelanggan(index);
                },
              );
            default:
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    // SizedBox(height: 8), // Add some space between the loading indicator and text
                    // Text("Loading data user"),
                  ],
                ),
              );
          }
        } else {
          // Jika gagal mendapatkan peran pengguna, tampilkan widget alternatif atau pesan kesalahan
          return const Center(child: Text("Failed to fetch user role"));
        }
      }),
    );
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
    switch (index) {
      case 0:
        Get.offAllNamed(Routes.KARYAWANHOME);
        break;
      case 1:
        Get.offAllNamed(Routes.KARYAWAN_DASHBOARD);
        break;
      case 2:
        Get.offAllNamed(Routes.KARYAWANPROFILE);
        break;
      default:
    }
  }

  void _handleNavigationPelanggan(int index) {
    switch (index) {
      case 0:
        Get.offAllNamed(Routes.PELANGGANHOME);
        break;
      case 1:
        Get.offAllNamed(Routes.PELANGGAN_DASBOARD);
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
