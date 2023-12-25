import 'package:get/get.dart';

import '../controllers/pelanggan_dasboard_controller.dart';

class PelangganDasboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PelangganDasboardController>(
      () => PelangganDasboardController(),
    );
  }
}
