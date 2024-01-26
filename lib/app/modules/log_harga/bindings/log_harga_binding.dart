import 'package:get/get.dart';

import '../controllers/log_harga_controller.dart';

class LogHargaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LogHargaController>(
      () => LogHargaController(),
    );
  }
}
