import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/ownerlogin_controller.dart';

class OwnerloginView extends GetView<OwnerloginController> {
  const OwnerloginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OwnerloginView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'OwnerloginView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
