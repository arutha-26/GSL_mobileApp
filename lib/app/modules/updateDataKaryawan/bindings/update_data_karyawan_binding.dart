import 'package:get/get.dart';

import '../controllers/update_data_karyawan_controller.dart';

class UpdateDataKaryawanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UpdateDataKaryawanController>(
      () => UpdateDataKaryawanController(),
    );
  }
}
