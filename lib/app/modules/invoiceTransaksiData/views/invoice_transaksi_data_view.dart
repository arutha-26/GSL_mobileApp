import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/invoiceData.dart';
import '../controllers/invoice_transaksi_data_controller.dart';

class InvoiceTransaksiDataView extends GetView<InvoiceTransaksiDataController> {
  final RxList<InvoiceData> invoiceData;

  InvoiceTransaksiDataView({required this.invoiceData, Key? key}) : super(key: key);

  // TIDAK TERPAKAI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Transaksi'),
        centerTitle: true,
      ),
      body: Obx(
        () {
          if (controller.isLoading.isTrue) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemCount: controller.invoiceData.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Transaction ID: ${controller.nameController.text.toString()}'),
                  subtitle: Text('Amount: ${controller.invoiceData[index].idTransaksi}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
