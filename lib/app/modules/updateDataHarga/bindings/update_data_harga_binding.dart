import 'package:get/get.dart';

import '../controllers/update_data_harga_controller.dart';

class UpdateDataHargaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UpdateDataHargaController>(
      () => UpdateDataHargaController(),
    );
  }
}
