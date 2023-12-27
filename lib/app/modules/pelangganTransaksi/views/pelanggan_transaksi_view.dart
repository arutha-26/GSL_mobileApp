import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/pelanggan_transaksi_controller.dart';

class PelangganTransaksiView extends GetView<PelangganTransaksiController> {
  const PelangganTransaksiView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PelangganTransaksiView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PelangganTransaksiView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
