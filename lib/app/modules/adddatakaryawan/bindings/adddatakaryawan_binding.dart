import 'package:get/get.dart';

import '../controllers/adddatakaryawan_controller.dart';

class AdddatakaryawanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdddatakaryawanController>(
      () => AdddatakaryawanController(),
    );
  }
}
