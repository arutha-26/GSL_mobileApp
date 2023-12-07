import 'package:get/get.dart';

import '../controllers/karyawanhome_controller.dart';

class KaryawanhomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KaryawanhomeController>(
      () => KaryawanhomeController(),
    );
  }
}
