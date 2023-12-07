import 'package:get/get.dart';

import '../controllers/adddatapelanggan_controller.dart';

class AdddatapelangganBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdddatapelangganController>(
      () => AdddatapelangganController(),
    );
  }
}
