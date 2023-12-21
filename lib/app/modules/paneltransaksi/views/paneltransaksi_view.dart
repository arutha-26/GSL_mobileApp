import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/paneltransaksi_controller.dart';

class PaneltransaksiView extends GetView<PaneltransaksiController> {
  const PaneltransaksiView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PaneltransaksiView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PaneltransaksiView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
