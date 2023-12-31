import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/update_data_karyawan_controller.dart';

class UpdateDataKaryawanView extends GetView<UpdateDataKaryawanController> {
  const UpdateDataKaryawanView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UpdateDataKaryawanView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'UpdateDataKaryawanView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
