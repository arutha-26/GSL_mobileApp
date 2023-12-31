import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/detail_karyawan_controller.dart';

class DetailKaryawanView extends GetView<DetailKaryawanController> {
  const DetailKaryawanView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DetailKaryawanView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'DetailKaryawanView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
