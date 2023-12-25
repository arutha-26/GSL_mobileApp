import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/karyawan_dashboard_controller.dart';

class KaryawanDashboardView extends GetView<KaryawanDashboardController> {
  KaryawanDashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KaryawanDashboardView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'KaryawanDashboardView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
