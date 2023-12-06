import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/ownerhome_controller.dart';

class OwnerhomeView extends GetView<OwnerhomeController> {
  const OwnerhomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OwnerhomeView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'OwnerhomeView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
