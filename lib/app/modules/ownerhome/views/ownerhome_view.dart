import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:gsl/app/modules/dataKaryawan/controllers/data_karyawan_controller.dart';
import 'package:gsl/app/modules/dataKaryawan/views/data_karyawan_view.dart';

import '../../../routes/app_pages.dart';
import '../../../utils/bottom_navbar.dart';
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
import '../../paneltransaksi/controllers/paneltransaksi_controller.dart';
import '../../paneltransaksi/views/paneltransaksi_view.dart';
import '../../pengambilanLaundry/controllers/pengambilan_laundry_controller.dart';
import '../../pengambilanLaundry/views/pengambilan_laundry_view.dart';
import '../controllers/ownerhome_controller.dart';

class OwnerhomeView extends GetView<OwnerhomeController> {
  const OwnerhomeView({
    super.key,
  });

  void navigateBack() {
    // Clear input data before navigating back
    controller.clearInputs();

    // Navigate back
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 253, 253, 253),
      appBar: AppBar(
        title: const Text('Green Spirit Laundry'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
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
            SizedBox(
              width: 1000, // Set the width to the screen width
              height: 300.0, // Adjust the height based on your needs
              child: Scrollbar(
                thickness: 2,
                radius: const Radius.circular(20),
                scrollbarOrientation: ScrollbarOrientation.bottom,
                thumbVisibility: true,
                trackVisibility: true,
                interactive: true,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFFFFFFF),
                                // spreadRadius: 60.0, // Color of the shadow
                                // blurRadius: 50.0, // Spread of the shadow
                                // offset: Offset(-8, 6), // Offset of the shadow (x, y)
                              ),
                            ],
                            // Other decoration properties if needed
                          ),
                          width: 590,
                          child: GridView.count(
                            scrollDirection: Axis.horizontal,
                            crossAxisSpacing: 20.0,
                            mainAxisSpacing: 20.0,
                            padding: const EdgeInsets.all(16.0),
                            shrinkWrap: true,
                            // physics:
                            //     NeverScrollableScrollPhysics(), // Disable scrolling for the GridView
                            crossAxisCount: 2,
                            children: [
                              GlassButton(
                                onPressed: () {
                                  Get.deleteAll();
                                  Get.put(AdddataController());
                                  Get.to(() => AdddataView());
                                },
                                label: 'Data Pengguna',
                                color: Colors.blue,
                                iconPath: 'images/plus.png',
                              ),
                              GlassButton(
                                onPressed: () {
                                  Get.deleteAll();
                                  Get.put(AddtransaksiController());
                                  Get.to(() => AddtransaksiView());
                                },
                                label: 'Data Transaksi',
                                color: Colors.green,
                                iconPath: 'images/plus.png',
                              ),
                              GlassButton(
                                onPressed: () {
                                  Get.put(PaneltransaksiController());
                                  Get.to(() => PaneltransaksiView());
                                },
                                label: 'Panel Transaksi',
                                color: Colors.orange,
                                iconPath: 'images/settings.png',
                              ),
                              GlassButton(
                                onPressed: () {
                                  Get.deleteAll();
                                  Get.put(PengambilanLaundryController());
                                  Get.to(() => PengambilanLaundryView());
                                },
                                label: 'Update Data Laundry',
                                color: Colors.red,
                                iconPath: 'images/edit.png',
                              ),
                              GlassButton(
                                onPressed: () {
                                  Get.put(DatapelangganController());
                                  Get.to(() => DatapelangganView());
                                },
                                label: 'Data Pelanggan',
                                color: Colors.purple,
                                iconPath: 'images/document.png',
                              ),
                              GlassButton(
                                onPressed: () {
                                  Get.put(DataKaryawanController());
                                  Get.to(() => DataKaryawanView());
                                },
                                label: 'Data Karyawan',
                                color: Colors.purple,
                                iconPath: 'images/document.png',
                              ),
                              GlassButton(
                                onPressed: () {
                                  Get.deleteAll();
                                  Get.put(DataTransaksiController());
                                  Get.to(() => DataTransaksiView());
                                },
                                label: 'Data Transaksi',
                                color: Colors.teal,
                                iconPath: 'images/document.png',
                              ),
                              GlassButton(
                                onPressed: () {
                                  Get.deleteAll();
                                  Get.put(InvoiceTransaksiController());
                                  Get.to(() => InvoiceTransaksiView());
                                },
                                label: 'Invoice Transaksi',
                                color: Colors.teal,
                                iconPath: 'images/document.png',
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  },
                ),
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
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          // Handle navigation using Get
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
        },
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
