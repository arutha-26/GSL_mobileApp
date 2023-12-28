import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gsl/app/modules/addtransaksi/controllers/addtransaksi_controller.dart';
import 'package:gsl/app/modules/addtransaksi/views/addtransaksi_view.dart';
import 'package:gsl/app/modules/dataTransaksi/controllers/data_transaksi_controller.dart';
import 'package:gsl/app/modules/dataTransaksi/views/data_transaksi_view.dart';
import 'package:gsl/app/modules/paneltransaksi/controllers/paneltransaksi_controller.dart';
import 'package:gsl/app/modules/paneltransaksi/views/paneltransaksi_view.dart';
import 'package:gsl/app/modules/pengambilanLaundry/controllers/pengambilan_laundry_controller.dart';
import 'package:gsl/app/modules/pengambilanLaundry/views/pengambilan_laundry_view.dart';

import '../../../routes/app_pages.dart';
import '../../../utils/bottom_navbar.dart';
import '../../adddatauser/controllers/adddata_controller.dart';
import '../../adddatauser/views/adddata_view.dart';
import '../../datapelanggan/controllers/datapelanggan_controller.dart';
import '../../datapelanggan/views/datapelanggan_view.dart';
import '../controllers/ownerhome_controller.dart';

class OwnerhomeView extends GetView<OwnerhomeController> {
  const OwnerhomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Green Spirit Laundry'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
                  aspectRatio: 15 / 9,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: true,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  autoPlayAnimationDuration: const Duration(milliseconds: 2000),
                  viewportFraction: 1,
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  'Keberhasilan Green Spirit Laundry adalah hasil dari kerja keras dan semangat kalian.\n Mari kita terus tingkatkan kualitas layanan dan tunjukkan kepada semua bahwa kita adalah yang terbaik!',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                padding: const EdgeInsets.all(16.0),
                shrinkWrap: true,
                children: [
                  ElevatedButtonIcon(
                    onPressed: () {
                      Get.put(AdddataController());
                      Get.to(() => AdddataView());
                    },
                    imagePath: 'images/plus.png', // Replace with your image path
                    label: 'Data Karyawan/Pelanggan',
                    color: Colors.blue,
                  ),
                  ElevatedButtonIcon(
                    onPressed: () {
                      Get.put(AddtransaksiController());
                      Get.to(() => AddtransaksiView());
                    },
                    imagePath: 'images/plus.png', // Replace with your image path
                    label: 'Data Transaksi',
                    color: Colors.green,
                  ),
                  ElevatedButtonIcon(
                    onPressed: () {
                      Get.put(PaneltransaksiController());
                      Get.to(() => PaneltransaksiView());
                    },
                    imagePath: 'images/settings.png', // Replace with your image path
                    label: 'Panel Transaksi',
                    color: Colors.orange,
                  ),
                  ElevatedButtonIcon(
                    onPressed: () {
                      Get.put(PengambilanLaundryController());
                      Get.to(() => PengambilanLaundryView());
                    },
                    imagePath: 'images/edit.png', // Replace with your image path
                    label: 'Update Data Laundry',
                    color: Colors.red,
                  ),
                  ElevatedButtonIcon(
                    onPressed: () {
                      Get.put(DatapelangganController());
                      Get.to(() => DatapelangganView());
                    },
                    imagePath: 'images/document.png', // Replace with your image path
                    label: 'Data Pelanggan',
                    color: Colors.purple,
                  ),
                  ElevatedButtonIcon(
                    onPressed: () {
                      Get.put(DataTransaksiController());
                      Get.to(() => DataTransaksiView());
                    },
                    imagePath: 'images/document.png', // Replace with your image path
                    label: 'Data Transaksi',
                    color: Colors.teal,
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
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

class ElevatedButtonIcon extends StatelessWidget {
  final VoidCallback onPressed;
  final String imagePath;
  final String label;
  final Color color;

  ElevatedButtonIcon({
    required this.onPressed,
    required this.imagePath,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 32, // Adjust the height of the image
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}