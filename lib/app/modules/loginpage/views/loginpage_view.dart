import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controllers.dart';
import '../controllers/loginpage_controller.dart';

class LoginpageView extends GetView<LoginpageController> {
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
                'Selamat Datang di Green Spirit Laundry!', // Tambahkan teks welcome di sini
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
                  hintText: 'Example@gsl.com',
                  hintStyle: TextStyle(color: Colors.grey), // Optional: Set hint text color
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
              Obx(() => Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16.0), // Optional: Set margin for spacing
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(const Color(0xFF00FFA6)),
                      ),
                      onPressed: () async {
                        if (controller.isLoading.isFalse) {
                          bool? cekAutoLogout = await controller.login();
                          if (cekAutoLogout != null && cekAutoLogout == true) {
                            await authC.autoLogout();
                          }
                        }
                      },
                      child: Text(
                        controller.isLoading.isFalse ? "LOGIN" : "Loading...",
                        style: const TextStyle(
                          color: Colors.black, // Set the text color to white
                          fontWeight: FontWeight.bold, // Set the text to bold
                        ),
                      ),
                    ),
                  )),
              const SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
