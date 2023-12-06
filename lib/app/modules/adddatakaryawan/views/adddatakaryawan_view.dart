import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:gsl/app/modules/ownerhome/controllers/ownerhome_controller.dart';

import '../../home/controllers/home_controller.dart';
import '../controllers/adddatakaryawan_controller.dart';

// TODO: TAMBAHIN TEXT FIELD UNTUK NAMA, NO HP COBA ADD DATA SAMA TAMPILIN

class AdddatakaryawanView extends GetView<AdddatakaryawanController> {

  OwnerhomeController homeC = Get.find(); // get controller from another controller

  AdddatakaryawanView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Data Karyawan'),
        centerTitle: true,
      ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextField(
              controller: controller.titleC,
              decoration: const InputDecoration(
                labelText: "Nama",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            TextField(
              controller: controller.descC,
              decoration: const InputDecoration(
                labelText: "No HP",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Obx(() => ElevatedButton(
                onPressed: () async {
                  if (controller.isLoading.isFalse) {
                    bool res = await controller.addNote();
                    if (res == true) {
                      await homeC.getAllKaryawan();
                      Get.back();
                    }
                    controller.isLoading.value = false;
                  }
                },
                child: Text(
                    controller.isLoading.isFalse ? "Tambah Data Karyawan" : "Loading...")))
          ],
        ));
  }
}
