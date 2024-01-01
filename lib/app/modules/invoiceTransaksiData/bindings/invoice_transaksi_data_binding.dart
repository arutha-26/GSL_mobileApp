import 'package:get/get.dart';

import '../controllers/invoice_transaksi_data_controller.dart';

class InvoiceTransaksiDataBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InvoiceTransaksiDataController>(
      () => InvoiceTransaksiDataController(),
    );
  }
}
