import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/addtransaksi_controller.dart';

class AddtransaksiView extends GetView<AddtransaksiController> {
  const AddtransaksiView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AddtransaksiView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AddtransaksiView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
