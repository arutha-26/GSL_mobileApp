import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gsl/app/modules/adddatakaryawan/controllers/adddatakaryawan_controller.dart';
import 'package:gsl/app/modules/adddatakaryawan/views/adddatakaryawan_view.dart';
import 'package:gsl/app/modules/adddatapelanggan/controllers/adddatapelanggan_controller.dart';
import 'package:gsl/app/modules/adddatapelanggan/views/adddatapelanggan_view.dart';
import 'package:gsl/app/modules/addtransaksi/controllers/addtransaksi_controller.dart';
import 'package:gsl/app/modules/addtransaksi/views/addtransaksi_view.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/bottom_navbar.dart';
import '../../adddata/controllers/adddata_controller.dart';
import '../../adddata/views/adddata_view.dart';
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
                  Get.put(AdddatapelangganController());
                  Get.to(() => AdddatapelangganView());
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
                  Get.put(DatapelangganController());
                  Get.to(() => DatapelangganView());
                },
                icon: Icon(Icons.add),
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
