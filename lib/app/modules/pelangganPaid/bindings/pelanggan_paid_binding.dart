import 'package:get/get.dart';

import '../controllers/pelanggan_paid_controller.dart';

class PelangganPaidBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PelangganPaidController>(
      () => PelangganPaidController(),
    );
  }
}
