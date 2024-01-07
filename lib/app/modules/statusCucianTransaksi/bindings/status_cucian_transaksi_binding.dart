import 'package:get/get.dart';

import '../controllers/status_cucian_transaksi_controller.dart';

class StatusCucianTransaksiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StatusCucianTransaksiController>(
      () => StatusCucianTransaksiController(),
    );
  }
}
