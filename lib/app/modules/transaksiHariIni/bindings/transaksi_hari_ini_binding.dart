import 'package:get/get.dart';

import '../controllers/transaksi_hari_ini_controller.dart';

class TransaksiHariIniBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransaksiHariIniController>(
      () => TransaksiHariIniController(),
    );
  }
}
