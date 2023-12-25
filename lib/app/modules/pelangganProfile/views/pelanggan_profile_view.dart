import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controllers.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/bottom_navbar.dart';
import '../controllers/pelanggan_profile_controller.dart';

class PelangganProfileView extends GetView<PelangganProfileController> {
  PelangganProfileView({super.key});

  final authC = Get.find<AuthController>();
  int tabNow = 2;

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
              child: const Text(
                "LOGOUT",
                style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
              ))
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
                        controller.nameC.text,
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
                  // enabled: false,
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
                Obx(() => ElevatedButton(
                      onPressed: () async {
                        if (controller.isLoading.isFalse) {
                          if (controller.nameC.text == controller.nameC2.text &&
                              controller.passwordC.text.isEmpty) {
                            // Check if user have same name and not want to change password but they click the button
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
                      child:
                          Text(controller.isLoading.isFalse ? "UPDATE PROFILE" : "Loading..."),
                    )),
              ],
            );
          }),
      bottomNavigationBar: Obx(() {
        String? userRole = controller.userRole.value;

        if (userRole != null) {
          return BottomNavBar(
            currentIndex: 2,
            onTap: (index) {
              controller.onPageChanged(index);
              _handleNavigation(index, userRole);
            },
          );
        } else {
          // Jika gagal mendapatkan peran pengguna, tampilkan widget alternatif atau pesan kesalahan
          return const Center(child: Text("Failed to fetch user role"));
        }
      }),
    );
  }

  // int _getCurrentIndexForRole(int tabNow) {
  //   switch (tabNow) {
  //     case 0:
  //       // if (kDebugMode) {
  //       //   print(controller.selectedIndexOwner.value);
  //       // }
  //       // return controller.selectedIndexOwner.value;
  //     case 1:
  //       // if (kDebugMode) {
  //       //   print(controller.selectedIndexKaryawan.value);
  //       // }
  //       // return controller.selectedIndexKaryawan.value;
  //     case 2:
  //       // if (kDebugMode) {
  //       //   print(controller.selectedIndexPelanggan.value);
  //       // }
  //       // return controller.selectedIndexPelanggan.value;
  //     default:
  //       return 0;
  //   }
  // }
  void _handleNavigation(int index, String userRole) {
    controller.onPageChanged(index); // Pastikan onPageChanged dipanggil terlebih dahulu
    switch (userRole) {
      case 'Owner':
        _handleNavigationOwner(index);
        break;
      case 'Karyawan':
        _handleNavigationKaryawan(index);
        break;
      case 'Pelanggan':
        _handleNavigationPelanggan(index);
        break;
      default:
        Get.snackbar("ERROR", "Unknown user role");
        break;
    }
  }

  int _getCurrentIndexForRole(String userRole) {
    switch (userRole) {
      case 'Owner':
        return controller.selectedIndexOwner.value;
      case 'Karyawan':
        return controller.selectedIndexKaryawan.value;
      case 'Pelanggan':
        return controller.selectedIndexPelanggan.value;
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
    switch (index) {
      case 0:
        Get.offAllNamed(Routes.KARYAWANHOME);
        break;
      case 1:
        Get.offAllNamed(Routes.KARYAWANHOME);
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
        Get.offAllNamed(Routes.PELANGGANHOME);
        break;
      case 2:
        Get.offAllNamed(Routes.PELANGGAN_PROFILE);
        tabNow == 2;
        if (kDebugMode) {
          print('sekarang tab ke- $tabNow setelah berpindah');
        }
        break;
      default:
    }
  }
}