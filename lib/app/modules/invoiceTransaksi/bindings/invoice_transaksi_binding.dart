import 'package:get/get.dart';

import '../controllers/invoice_transaksi_controller.dart';

class InvoiceTransaksiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InvoiceTransaksiController>(
      () => InvoiceTransaksiController(),
    );
  }
}
