import 'package:get/get.dart';

import '../controllers/pelanggan_transaksi_controller.dart';

class PelangganTransaksiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PelangganTransaksiController>(
      () => PelangganTransaksiController(),
    );
  }
}
