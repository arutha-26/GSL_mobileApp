import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/pelanggan_debt_controller.dart';

class PelangganDebtView extends GetView<PelangganDebtController> {
  const PelangganDebtView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PelangganDebtView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PelangganDebtView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
