import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/pelanggan_profile_controller.dart';

class PelangganProfileView extends GetView<PelangganProfileController> {
  const PelangganProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PelangganProfileView'), centerTitle: true, actions: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.offAllNamed(Routes.PELANGGANHOME);
          },
        )
      ]),
      body: const Column(
        children: [
          Center(
            child: Text(
              'PelangganProfileView is working',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
