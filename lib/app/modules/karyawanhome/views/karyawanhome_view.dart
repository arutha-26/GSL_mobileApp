import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:gsl/app/utils/bottom_navbar_karyawan.dart';

import '../../../routes/app_pages.dart';
import '../../../utils/quote_carousel.dart';
import '../../adddatauser/controllers/adddata_controller.dart';
import '../../adddatauser/views/adddata_view.dart';
import '../../addtransaksi/controllers/addtransaksi_controller.dart';
import '../../addtransaksi/views/addtransaksi_view.dart';
import '../../dataTransaksi/controllers/data_transaksi_controller.dart';
import '../../dataTransaksi/views/data_transaksi_view.dart';
import '../../datapelanggan/controllers/datapelanggan_controller.dart';
import '../../datapelanggan/views/datapelanggan_view.dart';
import '../../invoiceTransaksi/controllers/invoice_transaksi_controller.dart';
import '../../invoiceTransaksi/views/invoice_transaksi_view.dart';
import '../../pengambilanLaundry/controllers/pengambilan_laundry_controller.dart';
import '../../pengambilanLaundry/views/pengambilan_laundry_view.dart';
import '../controllers/karyawanhome_controller.dart';

class KaryawanhomeView extends GetView<KaryawanhomeController> {
  KaryawanhomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 253, 253, 253),
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
      body: Obx(() {
        if (controller.isLoading.isTrue) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Scrollbar(
            thumbVisibility: true,
            trackVisibility: true,
            interactive: true,
            scrollbarOrientation: ScrollbarOrientation.right,
            thickness: 10,
            radius: const Radius.circular(20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CarouselSlider(
                    items: [
                      Image.asset('images/banner_1.png'),
                      Image.asset('images/banner_4.png'),
                      Image.asset('images/banner_7.png'),
                      Image.asset('images/banner_5.png'),
                    ],
                    options: CarouselOptions(
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: true,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      autoPlayAnimationDuration: const Duration(milliseconds: 2500),
                      viewportFraction: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: _buildProfitAndTransactionCountCard(),
                  ),
                  SizedBox(
                    width: 450, // Set the width to the screen width
                    height: 300.0, // Adjust the height based on your needs
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return GridView.count(
                          scrollDirection: Axis.vertical,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                          padding: const EdgeInsets.fromLTRB(5, 15, 5, 15),
                          shrinkWrap: true,
                          // physics:
                          //     NeverScrollableScrollPhysics(), // Disable scrolling for the GridView
                          crossAxisCount: 3,
                          children: [
                            GlassButton(
                              onPressed: () {
                                // Get.deleteAll();
                                Get.put(AdddataController());
                                Get.to(() => AdddataView());
                              },
                              label: 'Tambah\nPengguna',
                              color: Colors.blue,
                              iconPath: 'images/user-add.png',
                            ),
                            GlassButton(
                              onPressed: () {
                                Get.put(AddtransaksiController());
                                Get.to(() => AddtransaksiView());
                              },
                              label: 'Tambah\nTransaksi',
                              color: Colors.green,
                              iconPath: 'images/hand-holding-usd.png',
                            ),
                            GlassButton(
                              onPressed: () {
                                Get.deleteAll();
                                Get.put(PengambilanLaundryController());
                                Get.to(() => PengambilanLaundryView());
                              },
                              label: 'Update\nTransaksi',
                              color: Colors.red,
                              iconPath: 'images/edit.png',
                            ),
                            GlassButton(
                              onPressed: () {
                                Get.put(DatapelangganController());
                                Get.to(() => DatapelangganView());
                              },
                              label: 'Data\nPelanggan',
                              color: Colors.purple,
                              iconPath: 'images/users-alt.png',
                            ),
                            GlassButton(
                              onPressed: () {
                                Get.deleteAll();
                                Get.put(DataTransaksiController());
                                Get.to(() => DataTransaksiView());
                              },
                              label: 'Data\nTransaksi',
                              color: Colors.teal,
                              iconPath: 'images/document.png',
                            ),
                            GlassButton(
                              onPressed: () {
                                Get.deleteAll();
                                Get.put(InvoiceTransaksiController());
                                Get.to(() => InvoiceTransaksiView());
                              },
                              label: 'Cetak\nTransaksi',
                              color: Colors.teal,
                              iconPath: 'images/file-invoice-dollar.png',
                            )
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  // TERAPKAN DISINI
                  QuoteCarousel(),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          );
        }
      }),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          // Handle navigation using Get
          switch (index) {
            case 0:
              Get.offAllNamed(Routes.KARYAWANHOME);
              break;
            case 1:
              Get.offAllNamed(Routes.KARYAWANPROFILE);
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
