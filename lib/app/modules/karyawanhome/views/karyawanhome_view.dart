import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/karyawanhome_controller.dart';

class KaryawanhomeView extends GetView<KaryawanhomeController> {
  const KaryawanhomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KaryawanhomeView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'KaryawanhomeView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
