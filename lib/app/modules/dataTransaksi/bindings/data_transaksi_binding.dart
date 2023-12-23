import 'package:get/get.dart';

import '../controllers/data_transaksi_controller.dart';

class DataTransaksiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DataTransaksiController>(
      () => DataTransaksiController(),
    );
  }
}
