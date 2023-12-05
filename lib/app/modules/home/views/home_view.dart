import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:gsl/app/modules/karyawanlogin/views/karyawanlogin_view.dart';
import 'package:gsl/app/modules/ownerlogin/views/ownerlogin_view.dart';
import '../../ownerlogin/controllers/ownerlogin_controller.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // color: const Color(0xFFCFD8C7),
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('images/gsl_logo.png'), fit: BoxFit.cover),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 300),
              ElevatedButton(
                onPressed: () {
                  // Initialize the controller before navigating to OwnerloginView
                  Get.put(OwnerloginController());

                  // Now navigate to OwnerloginView
                  Get.to(() => OwnerloginView());
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  backgroundColor: Color(0xFF87cb91),
                  elevation: 5,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'images/owner_icon.png',
                      height: 100,
                    ),
                    SizedBox(width: 50), // Jarak antara gambar dan teks
                    const Text(
                      "Owner",
                      style: TextStyle(fontSize: 30, color: Colors.black87),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Get.to(() => KaryawanloginView());
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  backgroundColor: Color(0xFF87cb91),
                  elevation: 5,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'images/karyawan_icon.png',
                      height: 100,
                    ),
                    SizedBox(width: 50), // Jarak antara gambar dan teks
                    Text(
                      "Karyawan",
                      style: TextStyle(fontSize: 30, color: Colors.black87),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Get.to(() => KaryawanloginView());
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  backgroundColor: Color(0xFF87cb91),
                  elevation: 5,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'images/pelanggan_icon.png',
                      height: 100,
                    ),
                    SizedBox(width: 50), // Jarak antara gambar dan teks
                    Text(
                      "Pelanggan",
                      style: TextStyle(fontSize: 30, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
