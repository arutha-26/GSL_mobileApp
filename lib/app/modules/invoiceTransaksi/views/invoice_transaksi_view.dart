import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/invoice_transaksi_controller.dart';

class InvoiceTransaksiView extends GetView<InvoiceTransaksiController> {
  InvoiceTransaksiView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice Transaksi'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'InvoiceTransaksiView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
