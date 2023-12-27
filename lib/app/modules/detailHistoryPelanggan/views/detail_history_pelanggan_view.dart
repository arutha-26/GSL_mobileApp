import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/detail_history_pelanggan_controller.dart';

class DetailHistoryPelangganView extends GetView<DetailHistoryPelangganController> {
  const DetailHistoryPelangganView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DetailHistoryPelangganView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'DetailHistoryPelangganView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
