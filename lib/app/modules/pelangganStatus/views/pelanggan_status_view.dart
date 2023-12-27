import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/pelanggan_status_controller.dart';

class PelangganStatusView extends GetView<PelangganStatusController> {
  const PelangganStatusView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PelangganStatusView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PelangganStatusView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
