import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/data_karyawan_controller.dart';

class DataKaryawanView extends GetView<DataKaryawanController> {
  DataKaryawanView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DataKaryawanView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'DataKaryawanView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
