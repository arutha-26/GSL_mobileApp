import 'package:get/get.dart';

import '../controllers/detail_data_transaksi_controller.dart';

class DetailDataTransaksiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailDataTransaksiController>(
      () => DetailDataTransaksiController(),
    );
  }
}
