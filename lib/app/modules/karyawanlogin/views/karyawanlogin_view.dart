import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/karyawanlogin_controller.dart';

class KaryawanloginView extends GetView<KaryawanloginController> {
  const KaryawanloginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KaryawanloginView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'KaryawanloginView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
