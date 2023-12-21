import 'package:get/get.dart';

import '../controllers/paneltransaksi_controller.dart';

class PaneltransaksiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaneltransaksiController>(
      () => PaneltransaksiController(),
    );
  }
}
