import 'package:get/get.dart';

import '../controllers/pelanggan_status_controller.dart';

class PelangganStatusBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PelangganStatusController>(
      () => PelangganStatusController(),
    );
  }
}
