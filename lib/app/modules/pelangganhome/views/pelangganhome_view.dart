import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../controllers/auth_controllers.dart';
import '../../../routes/app_pages.dart';
import '../controllers/pelangganhome_controller.dart';

class PelangganhomeView extends GetView<PelangganhomeController> {
  PelangganhomeView({Key? key}) : super(key: key);

  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pelanngan Dashboard'),
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
                style: TextStyle(color: Colors.redAccent),
              ))
        ],
      ),
      body: const Center(
        child: Text(
          'PelangganhomeView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
