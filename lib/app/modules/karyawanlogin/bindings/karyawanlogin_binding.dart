import 'package:get/get.dart';

import '../controllers/karyawanlogin_controller.dart';

class KaryawanloginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KaryawanloginController>(
      () => KaryawanloginController(),
    );
  }
}
