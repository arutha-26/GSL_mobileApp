import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../controllers/auth_controllers.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/bottom_navbar.dart';
import '../controllers/datapelanggan_controller.dart';

class DatapelangganView extends GetView<DatapelangganController> {
  DatapelangganView({Key? key}) : super(key: key);
  final authC = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Data Pelanggan'),
        centerTitle: true,
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
                Center(
                  child: Text(
                    controller.emailC.text,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  autocorrect: false,
                  controller: controller.nameC2,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    labelText: "Nama",
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
                  child: Text(
                      controller.isLoading.isFalse ? "UPDATE PROFILE" : "Loading..."),
                )),
              ],
            );
          }),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          // Handle navigation using Get
          switch (index) {
            case 0:
              Get.offAllNamed(Routes.OWNERHOME); // Replace '/home' with your actual home route
              break;
            case 1:
              Get.offAllNamed('/dashboard'); // Replace '/dashboard' with your actual dashboard route
              break;
            case 2:
              Get.offAllNamed(Routes.OWNERPROFILE); // Replace '/profile' with your actual profile route
              break;
            default:
          }
        },
      ),
    );
  }
}
