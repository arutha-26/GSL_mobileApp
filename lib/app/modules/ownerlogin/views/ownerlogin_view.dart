import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controllers.dart';
import '../../../routes/app_pages.dart';
import '../controllers/ownerlogin_controller.dart';

class OwnerloginView extends GetView<OwnerloginController> {
  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('images/gsl_logo.png'), fit: BoxFit.cover),
        ),
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'Selamat Datang di Green Spirit Laundry, Owner!', // Tambahkan teks welcome di sini
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                autocorrect: false,
                controller: controller.emailC,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.black87),
                ),
              ),
              const SizedBox(height: 16),
              Obx(() => TextFormField(
                controller: controller.passwordC,
                textInputAction: TextInputAction.done,
                obscureText: controller.isHidden.value,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () => controller.isHidden.toggle(),
                      icon: controller.isHidden.isTrue
                          ? const Icon(Icons.remove_red_eye)
                          : const Icon(Icons.remove_red_eye_outlined)),
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.black87),
                ),
              )),
              const SizedBox(height: 24),
              Obx(() => ElevatedButton(
                onPressed: () async {
                  if (controller.isLoading.isFalse) {
                    bool? cekAutoLogout = await controller.login();
                    if (cekAutoLogout != null && cekAutoLogout == true) {
                      await authC.autoLogout();
                      Get.offAllNamed(Routes.OWNERHOME);
                    }
                  }
                },
                child: Text(controller.isLoading.isFalse ? "LOGIN" : "Loading..."),
              )),
              const SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
