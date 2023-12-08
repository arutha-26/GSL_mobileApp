import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/datapelanggan_controller.dart';

class DatapelangganView extends GetView<DatapelangganController> {
  const DatapelangganView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DatapelangganView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'DatapelangganView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
