import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gsl/app/modules/addtransaksi/controllers/addtransaksi_controller.dart';
import 'package:gsl/app/modules/addtransaksi/views/addtransaksi_view.dart';
import 'package:gsl/app/modules/paneltransaksi/controllers/paneltransaksi_controller.dart';
import 'package:gsl/app/modules/paneltransaksi/views/paneltransaksi_view.dart';

import '../../../routes/app_pages.dart';
import '../../../utils/bottom_navbar.dart';
import '../../adddatauser/controllers/adddata_controller.dart';
import '../../adddatauser/views/adddata_view.dart';
import '../../datapelanggan/controllers/datapelanggan_controller.dart';
import '../../datapelanggan/views/datapelanggan_view.dart';
import '../controllers/ownerhome_controller.dart';

class OwnerhomeView extends GetView<OwnerhomeController> {
  const OwnerhomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Owner Green Spirit Laundry'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            Container(
              width: 350,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.put(AdddataController());
                  Get.to(() => AdddataView());
                },
                icon: Icon(Icons.add),
                label: Text('Tambah Data Karyawan/Pelanggan'),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              width: 350,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.put(AddtransaksiController());
                  Get.to(() => AddtransaksiView());
                },
                icon: Icon(Icons.add),
                label: Text('Tambah Data Transaksi'),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              width: 350,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.put(PaneltransaksiController());
                  Get.to(() => PaneltransaksiView());
                },
                icon: Icon(Icons.add),
                label: Text('Panel Transaksi'),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              width: 350,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.put(DatapelangganController());
                  Get.to(() => DatapelangganView());
                },
                icon: Icon(Icons.account_box_rounded),
                label: Text('Lihat Data Pelanggan'),
              ),
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
              Get.offAllNamed(Routes.OWNERHOME); // Replace '/home' with your actual home route
              break;
            case 1:
              Get.offAllNamed(
                  '/dashboard'); // Replace '/dashboard' with your actual dashboard route
              break;
            case 2:
              Get.offAllNamed(
                  Routes.OWNERPROFILE); // Replace '/profile' with your actual profile route
              break;
            default:
          }
        },
      ),
    );
  }
}
