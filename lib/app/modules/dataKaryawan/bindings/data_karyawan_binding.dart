import 'package:get/get.dart';

import '../controllers/data_karyawan_controller.dart';

class DataKaryawanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DataKaryawanController>(
      () => DataKaryawanController(),
    );
  }
}
