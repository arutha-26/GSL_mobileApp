import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controllers.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/bottom_navbar_pelanggan.dart';
import '../controllers/pelanggan_profile_controller.dart';

class PelangganProfileView extends GetView<PelangganProfileController> {
  PelangganProfileView({super.key});

  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Pelanggan'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () async {
              await controller.logout();
              await authC.resetTimer();
              Get.offAllNamed(Routes.LOGINPAGE);
            },
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0), // Sesuaikan dengan kebutuhan
                  side: const BorderSide(color: Colors.redAccent), // Warna dan lebar border
                ),
              ),
            ),
            child: const Text(
              "LOGOUT",
              style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
          future: controller.getProfile(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView(
              padding: const EdgeInsets.all(10),
              children: [
                const SizedBox(
                  height: 10,
                ),
                Image.asset(
                  'images/user_profile.png',
                  height: 300,
                  width: 300,
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Selamat Datang Kakak ',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        controller.nameC.text.capitalizeFirst.toString(),
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  autocorrect: false,
                  enabled: false,
                  controller: controller.emailC,
                  textInputAction: TextInputAction.none,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  autocorrect: false,
                  controller: controller.passwordC,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    labelText: "Password Baru",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Obx(
                  () => ElevatedButton(
                    onPressed: () async {
                      if (controller.isLoading.isFalse) {
                        if (controller.nameC.text == controller.nameC2.text &&
                            controller.passwordC.text.isEmpty) {
                          // Check if user has the same name and does not want to change the password but clicks the button
                          Get.snackbar("Info", "There is no data to update",
                              borderWidth: 1, borderColor: Colors.white, barBlur: 100);
                          return;
                        }
                        await controller.updateProfile();
                        if (controller.passwordC.text.isNotEmpty &&
                            controller.passwordC.text.length >= 6) {
                          await controller.logout();
                          await authC.resetTimer();
                          Get.offAllNamed(Routes.HOME);
                        }
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.greenAccent), // Warna latar belakang tombol
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.black), // Warna teks tombol
                    ),
                    child: Text(controller.isLoading.isFalse ? "Update Data" : "Loading..."),
                  ),
                ),
              ],
            );
          }),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          // Handle navigation using Get
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
        },
      ),
    );
  }
}
