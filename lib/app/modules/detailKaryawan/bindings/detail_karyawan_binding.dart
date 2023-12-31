import 'package:get/get.dart';

import '../controllers/detail_karyawan_controller.dart';

class DetailKaryawanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailKaryawanController>(
      () => DetailKaryawanController(),
    );
  }
}
