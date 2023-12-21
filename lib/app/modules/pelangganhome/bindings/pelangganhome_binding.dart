import 'package:get/get.dart';

import '../controllers/pelangganhome_controller.dart';

class PelangganhomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PelangganhomeController>(
      () => PelangganhomeController(),
    );
  }
}
