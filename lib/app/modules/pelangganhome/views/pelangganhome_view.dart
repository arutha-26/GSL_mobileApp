import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/pelangganhome_controller.dart';

class PelangganhomeView extends GetView<PelangganhomeController> {
  const PelangganhomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PelangganhomeView'),
        centerTitle: true,
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
