import 'package:get/get.dart';

import '../controllers/datapelanggan_controller.dart';

class DatapelangganBinding extends Bindings {
  @override
  void dependencies() {
    Get.appUpdate();
    Get.forceAppUpdate();
    Get.lazyPut<DatapelangganController>(
      () => DatapelangganController(),
    );
  }
}
