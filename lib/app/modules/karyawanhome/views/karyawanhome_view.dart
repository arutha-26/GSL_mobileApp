import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gsl/app/modules/adddatauser/controllers/adddata_controller.dart';

import '../../../routes/app_pages.dart';
import '../../../utils/bottom_navbar.dart';
import '../../adddatauser/views/adddata_view.dart';
import '../controllers/karyawanhome_controller.dart';

class KaryawanhomeView extends GetView<KaryawanhomeController> {
  KaryawanhomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Green Spirit Laundry'),
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
                label: Text('Tambah Data Karyawan'),
              ),
            ),
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
                label: Text('Tambah Data Pelanggan'),
              ),
            ),
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
                label: Text('Tambah Data Transaksi'),
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
              Get.offAllNamed(Routes.KARYAWANHOME); // Replace '/home' with your actual home route
              break;
            case 1:
              Get.offAllNamed(
                  '/dashboard'); // Replace '/dashboard' with your actual dashboard route
              break;
            case 2:
              Get.offAllNamed(
                  Routes.KARYAWANPROFILE); // Replace '/profile' with your actual profile route
              break;
            default:
          }
        },
      ),
    );
  }
}
